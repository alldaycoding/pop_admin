module PopAdmin::ModalHelper

  def modal(object, options = {})
    options.reverse_merge!(
      title: "",
      class: ""
    )

    modal_style = options[:class].strip.split(" ")
    modal_style += ["modal", "fade", controller_name, action_name]
    modal_style << "tabs" if options[:tabs]

    content = content_tag('div', class: modal_style.join(" ")) do
      content_tag("div", class: "modal-dialog") do
        content_tag("div", class: "modal-content") do
          content_tag("div", class: "modal-header") do
            button_tag("&times".html_safe, type: "button",
             class: "close", data: { dismiss: "modal" }, aria_hidden: "true") +
            content_tag("h4", options[:title], class: "modal-title")
          end +
          content_tag("div", class: "modal-body") do
            yield
          end +
          if options[:buttons]
            content_tag("div", class: "modal-footer") do
                options[:buttons].call()
            end
          else
            "".html_safe
          end
        end
      end
    end

    raw %Q{
      $("#{j content}").modal();
      #{trigger_ujs_event(object)}
    }
  end

  def modal_buttons(&block)
    proc(&block)
  end

  def modal_submit_button(options = {})
    options.reverse_merge!(title: I18n.t("action.save"),
      class: "btn btn-primary", data: {})
    options[:data][:action] = 'submit-modal-form'
    link_to(options.delete(:title), "#", options)
  end

  def modal_dismiss_button(options = {})
    options.reverse_merge!(title: I18n.t("action.dismiss"),
      class: "btn btn-default", data: {})
    options[:data][:dismiss] = 'modal'
    link_to(options.delete(:title), "#", options)
  end

  def form_modal(object, options = {})
    options[:buttons] = modal_buttons { modal_submit_button + modal_dismiss_button }
    modal(object, options) { yield }
  end

  def modal_response(object, options = {})
    options.reverse_merge!(action: 'save')

    res = %Q{
      $(".has-error .help-block").remove();
      $(".has-error").removeClass("has-error");
      $(".field-with-errors").removeClass("field-with-errors");
    }

    if object.errors.any?
      last_k = nil
      res << js_error_messages(object)
      res << %Q{Pop.notify.error("#{error_message(object, options[:action])}")}
    else
      res << %Q{$(".modal.#{controller_name}").modal("toggle");}
      res << %Q{Pop.notify.success("#{success_message(object, options[:action])}")}
      res << trigger_ujs_event(object)
    end

    raw res
  end

  def js_error_messages(object)
    last_k = nil
    model_name = object.class.model_name.to_s.underscore
    messages = object.errors.map do |k, v|
      if k.to_s != "base"
        if k != last_k
          if k =~ /^(.*)\.(.*)$/
            field = k.to_s.gsub!(/^(.*)\.(.*)$/, '\1_attributes_\2')
          else
            field = k
          end

          last_k = k
          %Q{
            $("##{model_name}_#{field}").closest(".form-group").addClass("has-error");
            $("##{model_name}_#{field}").closest(".control-wrapper").append("#{j js_error_msg(v)}");
          }
        end
      end
    end
    messages.compact.join("")
  end

  def js_error_msg(err)
    content_tag :p, :class => 'help-block' do
      err.to_s.capitalize
    end
  end

end
