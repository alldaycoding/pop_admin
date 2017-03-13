module PopAdmin::UjsHelper

  def trigger_ujs_event(object)
    success = object.errors.empty?
    raw %Q{
      $("body").trigger("ujs.#{controller_name}.#{action_name}", [#{object.to_json}, #{success}, #{object.errors.to_json}]);
    }
  end

  def ujs_form_response(object, options = {})
    options.reverse_merge!(action: 'save',
      redirect: false)

    res = js_remove_error_messages(object)

    if object.errors.any?
      last_k = nil
      res << js_error_messages(object)
      res << %Q{Pop.notify.error("#{error_message(object, options[:action])}")}
    else
      res << trigger_ujs_event(object)

      if options[:redirect]
        res << "Turbolinks.visit('#{options[:redirect]}');"
      end
    end

    raw res
  end

  def js_remove_error_messages(object)
    %Q{
      $(".has-error .help-block").remove();
      $(".has-error").removeClass("has-error");
      $(".field-with-errors").removeClass("field-with-errors");
    }
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
