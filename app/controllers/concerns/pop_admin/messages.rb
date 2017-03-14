module PopAdmin
  module Messages
    extend ActiveSupport::Concern

    included do
      helper_method :message, :success_message, :error_message
    end

    def message(object, action, status = :success)
      I18n.t("messages.#{object.class.model_name.to_s.underscore}.#{action}.#{status}",
        default: I18n.t("messages.#{action}.#{status}"))
    end

    def success_message(object, action)
      message(object, action, :success)
    end

    def error_message(object, action)
      message(object, action, :error)
    end

  end
end
