module PopAdmin::ModalHelper

  def modal(object, options = {})
    options.reverse_merge!(
      title: "",
      class: "",
      size: 'md',
      refresh: request.path
    )

    if params[:refresh]
      refresh_modal(object, options) { yield }
    else
      show_modal(object, options) { yield }
    end
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

    res = js_remove_error_messages(object)

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

  private

  def show_modal(object, options = {})
    modal_data = {}
    if options[:refresh]
      path = Rails.application.routes.recognize_path(options[:refresh])
      url = Rails.application.routes.url_for(path.merge(refresh: 1,
        only_path: true))
      modal_data[:refresh] = url
    end

    modal_style = options[:class].strip.split(" ")
    modal_style += ["modal", "fade", controller_name, action_name]
    modal_style << "tabs" if options[:tabs]

    content = content_tag('div', id: options[:id],
      class: modal_style.join(" "), data: modal_data) do
      content_tag("div", class: "modal-dialog modal-#{options[:size]}") do
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

  def refresh_modal(object, options = {})
    ref = if options[:id]
      "##{options[:id]}"
    else
      ".modal.#{controller_name}.#{action_name}"
    end

    content = capture { yield }

    raw %Q{
      li = $("#{ref} .modal-body").find('li.active');
      pos = $("#{ref} .modal-body li").index(li);
      $("#{ref} .modal-body").html("#{j content }");
      $("#{ref} .modal-body li:eq("+pos+") a").tab("show");
    }
  end

end
