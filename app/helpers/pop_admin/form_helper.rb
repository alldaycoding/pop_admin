module PopAdmin::FormHelper

  def horizontal_form_for(name, *args, &block)
    def_options = {
      builder: PopAdmin::Forms::FormBuilder,
      type: :horizontal
    }
    options = args.extract_options!
    form_for(name, *(args << options.merge(def_options)), &block)
  end

  def vertical_form_for(name, *args, &block)
    def_options = {
      builder: PopAdmin::Forms::FormBuilder,
      type: :vertical
    }
    options = args.extract_options!
    form_for(name, *(args << options.merge(def_options)), &block)
  end

  def form_buttons(model, options = {})
    options.reverse_merge!(icons: false)
    icon_style = options[:icons] ? "btn-icon icon-left" : ""
    content_tag('div', class: 'row') do
      content_tag('div', class: 'col-md-12') do
        content_tag('div', class: 'form-group pop-form-actions') do
          button_tag(class: "btn btn-primary #{icon_style}") do
            concat(options[:save_label] || t('action.save'))
            concat(content_tag('i', '', class: "entypo-check")) if options[:icons]
          end +
          link_to(model, class: "btn btn-default #{icon_style}") do
            concat(options[:cancel_label] || t('action.cancel'))
            concat(content_tag('i', '', class: 'entypo-cancel')) if options[:icons]
          end
        end
      end
    end
  end

end