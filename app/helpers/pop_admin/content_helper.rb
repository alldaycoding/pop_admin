module PopAdmin::ContentHelper

  def page_tabs(options = {})
    options.reverse_merge!(
      grid: { offset: 1, width: 10 }
    )

    grid_style = "col-sm-offset-#{options[:grid][:offset]} col-sm-#{options[:grid][:width]}"

    content_tag('section', class: 'pop-tabs-container') do
      content_tag('div', class: 'row') do
        content_tag('div', class: grid_style) do
          content_tag('ul', class: 'nav nav-tabs') do
            options[:tabs].collect do |name, tab|
              link_style = (options[:tabs].keys.first == name) ? "active" : ""
              content_tag('li', class: link_style) do
                link_to("#tab-#{name}", data: { toggle: 'tab' }) do
                  short_title = tab[:short_title] || tab[:title]
                  concat(content_tag('span', short_title, class: 'visible-xs'))
                  concat(content_tag('span', tab[:title], class: 'hidden-xs'))
                end
              end
            end.join().html_safe
          end
        end
      end
    end
  end

  def panel(options = {})
    options.reverse_merge!({
      collapse: false,
      class: ""
    })

    options[:class] = "#{options[:class]} panel minimal minimal-gray"

    content_tag('div', class: options[:class]) do
      content_tag('div', class: "panel-heading") do
        content_tag('div', options[:title], class: "panel-title") +
        content_tag('div', class: 'panel-options') do
          if options[:panel_buttons]
            options[:panel_buttons].call
          elsif options[:collapse]
            concat(link_to(content_tag('i', '', class: 'entypo-down-open'), '#', data: { rel: 'collapse' }))
          end
        end
      end +
      content_tag('div', class: 'panel-body') do
        yield
      end
    end
  end

  def record_tabs(options = {})
    content_tag('ul', class: 'nav nav-tabs pop-record-tabs') do
      options[:tabs].collect do |name, tab|
        link_style = (options[:tabs].keys.first == name) ? "active" : ""
        content_tag('li', class: link_style) do
          link_to("#tab-#{name}", data: { toggle: 'tab' }) do
            short_title = tab[:short_title] || tab[:title]
            concat(content_tag('span', short_title, class: 'visible-xs'))
            concat(content_tag('span', tab[:title], class: 'hidden-xs'))
          end
        end
      end.join().html_safe
    end

  end

  def info(label, value, options = {})
    options.reverse_merge!(orientation: 'horizontal')
    content_tag('p', class: "pop-info-box-#{options[:orientation]}") do
      content_tag('span', label, class: 'pop-info-label') +
      content_tag('span', value, class: 'pop-info-value')
    end
  end

  def model_info(model, attribute, options = {})
    info(ta(model, attribute), model.send(attribute), options)
  end

  def action_button(label, url, icon = nil, options = {})
    options.reverse_merge!(class: 'btn-default',
      title: label, visible: true)

    return unless options[:visible]

    class_arr = options[:class].split(" ").push("btn")
    if options[:type] == 'icon-left'
      class_arr += ["btn-icon", "icon-left"]
    elsif options[:type] == 'icon-right'
      class_arr += ["btn-icon", "icon-left"]
    elsif options[:type] == 'icon-only'
      class_arr << "icon-only"
    end

    options[:class] = class_arr.uniq.join(" ")

    link_to(url, options) do
      concat(label.html_safe) unless options[:type] == 'icon-only'
      concat(content_tag('i', '', class: icon)) unless icon.blank?
    end
  end

  def dropdown_button(label, icon = nil, options = {})
    options.reverse_merge!(class: "btn-default", visible: true,
      dropdown_style: '', container_class: '')

    return unless options[:visible]

    class_arr = options[:class].split(" ").push("btn")
    class_arr += ['btn', 'dropdown-toggle']
    if options[:type] == 'icon-left'
      class_arr += ["btn-icon", "icon-left"]
    elsif options[:type] == 'icon-right'
      class_arr += ["btn-icon", "icon-left"]
    elsif options[:type] == 'icon-only'
      class_arr << "icon-only"
    end
    options[:class] = class_arr.uniq.join(" ")

    if options[:visible]
      content_tag('div', class: "btn-group #{options[:container_class]}") do
        button_tag(type: 'button', class: options[:class],
          data: { toggle: 'dropdown' }) do
          concat(label.html_safe) unless options[:type] == 'icon-only'
          concat(content_tag('i', '', class: icon)) unless icon.blank?
        end +
        content_tag('ul', class: "dropdown-menu #{options[:dropdown_style]}") do
          yield if block_given?
        end
      end
    end
  end

  def dropdown_action(label, url, options = {})
    options.reverse_merge!(visible: true)

    if options[:visible]
      content_tag('li') do
        link_to(label, url, options)
      end
    end
  end

  def dropdown_action_sep
    content_tag('li', '', class: 'divider')
  end


end
