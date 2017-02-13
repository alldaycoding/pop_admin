module PopAdmin::HeaderHelper

  def page_header(title, options = {})
    options.reverse_merge!({ class: "", active: true })
    options[:class] += " row pop-page-header-container"
    options[:class] += " active" if options[:active]

    content_tag('div', options) do
      content_tag('div', class: "col-md-4 col-sm-2 hidden-xs") do
        content_tag 'ul', class: "list-inline links-list pull-left" do
          content_tag 'li', class: "pop-page-title" do
            content_tag('h3', title)
          end
        end
      end +
      content_tag('div', class: "col-md-8 col-sm-10 col-xs-12") do
        content_tag 'ul', class: "list-inline links-list pull-right pop-page-actions" do
          yield.html_safe if block_given?
        end
      end
    end
  end

  def page_action(label, url, icon = nil, options = {})
    options.reverse_merge!(class: 'btn-default', type: 'icon-left',
      title: label, visible: true)
    if options[:type] == 'icon-left'
      options[:class] = "btn btn-icon #{options[:class]} icon-left"
    elsif options[:type] == 'icon-only'
      options[:class] = "btn #{options[:class]} icon-only"
    end

    if options[:visible]
      content_tag('li', class: "pop-page-action") do
        link_to(url, options) do
          concat(label.html_safe) unless options[:type] == 'icon-only'
          concat(content_tag('i', '', class: icon)) if icon
        end
      end
    end
  end

  def page_action_group(options = {})
    options.reverse_merge!(class: "", visible: true)
    options[:class] += " pop-page-action"

    if options[:visible]
      content_tag('li', options) do
        content_tag('div', class: 'btn-group') do
          button_tag(type: 'button', class: 'btn btn-default icon-only dropdown-toggle',
            data: { toggle: 'dropdown' }) do
            content_tag('i', "", class: 'entypo-menu')
          end +
          content_tag('ul', class: 'dropdown-menu dropdown-menu-right') do
            if block_given?
              yield
            end
          end
        end
      end
    end
  end

  def secondary_page_actions(actions = {})
    if actions.any?
      page_action_group do
        actions.each do |name, opts|
          opts = opts.dup
          concat dropdown_action(opts.delete(:label), opts.delete(:url), opts)
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

  def page_action_sep
    content_tag('li', '', class: 'pop-page-action sep')
  end

  def dropdown_action_sep
    content_tag('li', '', class: 'divider')
  end

  def page_search
    content_tag('li', class: "pop-page-action pop-page-search hidden-xs") do
      form_tag('#', html: { class: 'pop-page-search' }) do
        content_tag('div', class: "input-group") do
          text_field_tag('page_search', '', class: 'form-control') +
          content_tag('div', class: 'input-group-btn') do
            button_tag(type: 'submit', class: 'btn btn-primary') do
              content_tag('i', '', class: 'entypo-search')
            end
          end
        end
      end
    end
  end

end
