require 'pop_admin/forms/inputs/base'
require 'pop_admin/forms/inputs/input_text'
require 'pop_admin/forms/inputs/input_check'
require 'pop_admin/forms/inputs/input_date'
require 'pop_admin/forms/inputs/input_password'
require 'pop_admin/forms/inputs/input_select'
require 'pop_admin/forms/inputs/input_string'
require 'pop_admin/forms/inputs/input_tag'
require 'pop_admin/forms/inputs/input_time'

module PopAdmin
  module Forms
    class FormBuilder <  ActionView::Helpers::FormBuilder

      attr_accessor :form_type

      def initialize(object_name, object, template, options)
        options.reverse_merge!(type: :vertical, html: {})
        @form_type = options.delete(:type)
        @form_style = "#{options[:html][:class]} form-#{@form_type}"
        options[:html][:class] = @form_style

        super
      end

      def input(method, options = {})
        options.reverse_merge!(as: :string)
        class_name = options.delete(:as).to_s.classify
        klass = "PopAdmin::Forms::Inputs::Input#{class_name}".constantize
        res = klass.new(self, @template, @object, @object_name, method, options)
        res.to_html
      end

      def localized_input(method, options = {})
        options[:label] ||= I18n.ta(@object, method)
        @template.localized_field do |locale|
          input("#{method}_#{locale}", options.dup)
        end
      end

      [:horizontal, :vertical].each do |ftype|
        define_method("#{ftype}?") do
          @form_type.to_sym == ftype
        end
      end

      def method_missing(method, *args)
        if method =~ /^input_(.+)$/
          options = args[1] || {}
          options[:as] = $1
          input(args[0], options)
        elsif method =~ /^localized_input_(.+)$/
          options = args[1] || {}
          options[:as] = $1
          localized_input(args[0], options)
        else
          super
        end
      end

    end
  end
end
