# frozen_string_literal: true

module PersonDuplicatesHelper

  def person_duplicates_table(entries)
    if entries.present?
      content_tag(:div, class: 'table-responsive') do
        PersonDuplicateTableBuilder.table(entries, @group, self)
      end
    else
      content_tag(:div, ti(:no_list_entries), class: 'table')
    end
  end
end
