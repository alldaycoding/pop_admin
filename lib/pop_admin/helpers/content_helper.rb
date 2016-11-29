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


end
