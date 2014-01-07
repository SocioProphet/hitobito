# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module LayoutHelper

  # render a single button
  def action_button(label, url, icon = nil, options = {})
    if @in_button_group || options[:in_button_group]
      button(label, url, icon, options)
    else
      button_group { button(label, url, icon, options) }
    end
  end

  def button_group(&block)
    if @in_button_group
      capture(&block)
    else
      in_button_group { content_tag(:div, class: 'btn-group', &block) }
    end
  end

  def in_button_group(&block)
    @in_button_group = true
    yield
  ensure
    @in_button_group = false
  end

  def pill_dropdown_button(dropdown, ul_classes = 'pull-right')
    dropdown.button_class = nil
    content_tag(:ul, class: "nav nav-pills #{ul_classes}") do
      content_tag(:li, class: 'dropdown') do
        in_button_group { dropdown.to_s }
      end
    end
  end

  def icon(name)
    content_tag(:i, '', class: "icon icon-#{name}")
  end

  def section(title, &block)
    render(layout: 'shared/section', locals: { title: title }, &block)
  end

  def section_table(title, collection, add_path = nil, &block)
    collection.inspect # force relation evaluation
    if add_path || collection.present?
      if add_path
        title = safe_join([title,
                           content_tag(:span,
                                       action_button('Erstellen', add_path, 'plus', class: 'btn-small'),
                                       class: 'pull-right')])
      end
      render(layout: 'shared/section_table',
             locals: { title: title, collection: collection, add_path: add_path },
             &block)
    end
  end

  def grouped_table(grouped_lists, column_count, &block)
    if grouped_lists.present?
      render(layout: 'shared/grouped_table',
             locals: { grouped_lists: grouped_lists, column_count: column_count },
             &block)
    else
      content_tag(:div, ti(:no_list_entries), class: 'table')
    end
  end

  def muted(text = nil, &block)
    content_tag(:span, text, class: 'muted', &block)
  end

  def value_with_muted(value, mute)
    safe_join([f(value), muted(mute)], ' ')
  end

  def element_visible(visible)
    "display: #{visible ? 'block' : 'none'};"
  end

  private

  def button(label, url, icon_name = nil, options = {})
    add_css_class options, 'btn'
    link_to(url, options) do
      html = [label]
      html.unshift icon(icon_name) if icon_name
      safe_join(html, ' ')
    end
  end

end
