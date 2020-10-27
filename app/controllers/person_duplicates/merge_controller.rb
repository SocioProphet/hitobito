# frozen_string_literal: true

#  Copyright (c) 2012-2020, CVP Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module PersonDuplicates
  class MergeController < ApplicationController

    before_action :authorize_action

    def new
      authorize!(:merge, entry)
    end

    def create
      authorize!(:merge, entry)
    end

    private

    def entry
      @entry ||= PersonDuplicate.find(params[:id])
    end

    def authorize_action
      authorize!(:manage_person_duplicates, group)
      authorize!(:merge, entry)
    end

    def group
      @group ||= Group.find(params[:group_id])
    end

  end
end
