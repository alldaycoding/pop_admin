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

  def page_action_sep
    content_tag('li', '', class: 'pop-page-action sep')
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

  def page_daterange(options = {})
    options.reverse_merge!(js_format: 'DD MMM YYYY', rb_format: '%d %b. %Y',
      start_date: Time.current, end_date: Time.current,
      locale: I18n.t("components.daterange"), ranges: true, opens: 'left')

    style = ["daterange", "daterange-inline"]
    style << "add-ranges" if options[:ranges]
    style << "pull-right" if options[:opens].to_s === 'left'

    data = options.slice(:locale, :table, :column)
    data.merge!(
      format: options[:js_format],
      start_date: I18n.l(options[:start_date], format: options[:rb_format]),
      end_date: I18n.l(options[:end_date], format: options[:rb_format])
    )

    init_value = "#{data[:start_date]} - #{data[:end_date]}"

    content_tag('li', class: "pop-page-action hidden-xs") do
      content_tag 'div', class: style.join(" "), data: data do
        content_tag('i', '', class: 'entypo-calendar') +
        content_tag('span', init_value)
      end
    end
  end

  def page_filters(options = {})
    content_tag('li', class: "") do
      content_tag('div', class: 'btn-group') do
        button_tag(content_tag('i', '', class: 'fa fa-filter'),
          class: 'btn btn-default icon-only dropdown-toggle',
          data: { toggle: 'dropdown' }) +

        content_tag('ul', class: 'dropdown-menu dropdown-menu-right filter-dropdown-menu') do
          content_tag('li') do
            content_tag('div', class: 'container-fluid') do
              form_tag('#', data: { table: options[:table] }) do
                filters_field = options[:filters].each do |f, options|
                  concat page_filter_field(f, options)
                end
                concat(page_filter_btns)
              end
            end
          end
        end
      end
    end
  end

  def page_filter_field(field, options)
    options.reverse_merge!(type: 'string')
    content_tag('div', class: 'row') do
      content_tag('div', class: 'col-md-12') do
        send("page_filter_#{options[:type]}", field, options)
      end
    end
  end

  def page_filter_btns
    content_tag('div', class: 'row') do
      content_tag('div', class: 'col-md-12') do
        content_tag('div', class: 'pop-form-actions') do
          submit_tag(t('common.filter'), class: 'btn btn-primary')
        end
      end
    end
  end

  def page_filter_string(field, options)
    field_name = "filter_#{field}"
    content_tag('div', class: 'form-group') do
      label_tag(field_name, options[:label], class: 'control-label') +
      content_tag('div', class: 'control-wrapper') do
        page_filter_type_field(field, :string, options) +
        text_field_tag(field_name, options[:value], class: 'form-control')
      end
    end
  end

  def page_filter_select(field, options)
    options.reverse_merge!(value_method: 'id', text_method: 'name')
    options[:data] ||= {}
    options[:data].reverse_merge!(
      allow_clear: true,
      language: I18n.locale
    )

    field_name = "filter_#{field}"

    if options[:collection].is_a?(ActiveRecord::Relation)
      select_opts = options_from_collection_for_select(options[:collection],
        options[:value_method], options[:text_method], options[:selected])
    else
      select_opts = options_for_select(options[:collection], options[:selected])
    end
    content_tag('div', class: 'form-group') do
      label_tag(field_name, options[:label], class: 'control-label') +
      content_tag('div', class: 'control-wrapper') do
        page_filter_type_field(field, :select, options) +
        select_tag(field_name, select_opts, class: 'form-control pop-select2',
          data: options[:data], include_blank: true)
      end
    end
  end

  def page_filter_bool(field, options)
    options.reverse_merge(checked: false)
    field_name = "filter_#{field}"
    content_tag('div', class: 'checkbox-wrapper') do
      content_tag('div', class: 'checkbox') do
        label_tag(field_name) do
          page_filter_type_field(field, :bool, options) +
          check_box_tag(field_name, '1', options[:checked], class: 'form-control') +
          options[:label]
        end
      end
    end
  end

  def page_filter_type_field(field, type, options = {})
    field_type = options[:custom] ? 'custom' : type
    hidden_field_tag("filter_type_#{field}", field_type)
  end

end
