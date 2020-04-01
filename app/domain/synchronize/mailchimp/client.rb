
#  Copyright (c) 2018, Grünliberale Partei Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'digest/md5'

module Synchronize
  module Mailchimp
    class Client
      attr_reader :list_id, :count, :api, :merge_fields, :member_fields

      def initialize(mailing_list, member_fields: [], merge_fields: [], count: 50, debug: false)
        @list_id = mailing_list.mailchimp_list_id
        @count   = count
        @merge_fields = merge_fields
        @member_fields = member_fields

        @api = Gibbon::Request.new(api_key: mailing_list.mailchimp_api_key, debug: debug)
      end

      def fetch_merge_fields
        paged do |list, params|
          body = api.lists(list_id).merge_fields.retrieve(params: params).body.to_h
          body['merge_fields'].each do |entry|
            list << entry.slice('tag', 'name', 'type').deep_symbolize_keys
          end
          body['total_items']
        end
      end

      def fetch_members
        fields = %w(email_address status tags merge_fields)
        fields += member_fields.collect(&:first).collect(&:to_s)

        paged do |list, params|
          body = api.lists(list_id).members.retrieve(params: params).body.to_h
          body['members'].each do |entry|
            list << entry.slice(*fields).deep_symbolize_keys
          end
          body['total_items']
        end
      end

      def fetch_segments
        paged do |list, params|
          body = api.lists(list_id).segments.retrieve(params: params).body.to_h
          body['segments'].each do |entry|
            list << entry.slice('id', 'name', 'member_count').symbolize_keys
          end
          body['total_items']
        end
      end

      def create_segments(names)
        execute_batch(names) do |name|
          create_segment_operation(name)
        end
      end

      def create_merge_fields(list)
        execute_batch(list) do |name, type, options|
          create_merge_field_operation(name, type, options)
        end
      end

      def update_segments(list)
        execute_batch(list) do |segment_id, emails|
          update_segment_operation(segment_id, emails)
        end
      end

      def delete(emails)
        execute_batch(emails) do |email|
          unsubscribe_member_operation(email)
        end
      end

      def delete_segments(segment_ids)
        execute_batch(segment_ids) do |segment_id|
          destroy_segment_operation(segment_id)
        end
      end

      def update_members(people)
        execute_batch(people) do |person|
          update_member_operation(person)
        end
      end

      def subscribe(people)
        execute_batch(people) do |person|
          subscribe_member_operation(person)
        end
      end

      def fetch_batch(batch_id)
        api.batches(batch_id).retrieve.body.fetch('response_body_url')
      end

      def create_merge_field_operation(name, type, options = {})
        {
          method: 'POST',
          path: "lists/#{list_id}/merge-fields",
          body: { tag: name.upcase, name: name, type: type, options: options }.to_json
        }
      end

      def create_segment_operation(name)
        {
          method: 'POST',
          path: "lists/#{list_id}/segments",
          body: { name: name, static_segment: [] }.to_json
        }
      end

      def destroy_segment_operation(segment_id)
        {
          method: 'DELETE',
          path: "lists/#{list_id}/segments/#{segment_id}",
        }
      end

      def update_segment_operation(segment_id, emails)
        {
          method: 'POST',
          path: "lists/#{list_id}/segments/#{segment_id}",
          body: { members_to_add: emails }.to_json
        }
      end

      def unsubscribe_member_operation(email)
        {
          method: 'DELETE',
          path: "lists/#{list_id}/members/#{subscriber_id(email)}"
        }
      end

      def subscribe_member_operation(person)
        {
          method: 'POST',
          path: "lists/#{list_id}/members",
          body: subscriber_body(person).merge(status: :subscribed).to_json
        }
      end

      def update_member_operation(person)
        {
          method: 'PUT',
          path: "lists/#{list_id}/members/#{subscriber_id(person.email)}",
          body: subscriber_body(person).to_json
        }
      end

      def subscriber_body(person)
        {
          email_address: person.email,
          merge_fields: {
            FNAME: person.first_name,
            LNAME: person.last_name,
          }.merge(merge_field_values(person))
        }.merge(member_field_values(person))
      end

      private

      def subscriber_id(email)
        Digest::MD5.hexdigest(email.downcase)
      end

      def paged(list = [], offset = 0, &block)
        total_items = block.call(list, count: count, offset: offset)
        next_offset = offset + count
        if total_items > next_offset
          paged(list, next_offset, &block)
        else
          list
        end
      end

      def execute_batch(list)
        operations = list.collect do |item|
          yield(item).tap do |operation|
            logger.info "mailchimp: #{list_id}, op: #{operation[:method]}, item: #{item}"
            logger.info operation
          end
        end

        if operations.present?
          batch_id = api.batches.create(body: { operations: operations }).body.fetch('id')
          wait_for_finish(batch_id)
        end
      end

      def wait_for_finish(batch_id, count = 0)
        sleep count * count
        body = api.batches(batch_id).retrieve.body
        status = body.fetch('status')

        logger.info "batch #{batch_id}, status: #{status}"
        fail "Batch #{batch_id} did not finish in due time, last status: #{status}" if count > 10

        if status != 'finished'
          wait_for_finish(batch_id, count + 1)
        else
          attrs = %w(total_operations finished_operations errored_operations response_body_url)
          body.slice(*attrs).tap do |updates|
            logger.info updates
          end
        end
      end

      def merge_field_values(person)
        merge_fields.collect do |field, type, options, evaluator|
          [field.upcase, evaluator.call(person)]
        end.to_h.deep_symbolize_keys
      end

      def member_field_values(person)
        member_fields.collect do |field, evaluator|
          [field,  evaluator.call(person)]
        end.to_h.deep_symbolize_keys
      end

      def logger
        Rails.logger
      end
    end
  end
end
