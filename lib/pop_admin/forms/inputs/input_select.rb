module PopAdmin
  module Forms
    module Inputs
      class InputSelect

        include Base

        def to_html
          organize_options

          container do
            label +
            field_wrapper { field }
          end
        end

        def field
          if @collection.is_a?(ActiveRecord::Relation)
            @builder.collection_select(@method,
              @collection, @value_method, @text_method,
              @select_config, @options)
          else
            @builder.select(@method, @collection, @select_config, @options)
          end
        end

        def organize_options
          @options.reverse_merge!(default_options)

          @options[:class] = field_style

          select2 = @options.delete(:select2)
          if select2
            @options[:class] = "#{@options[:class]} pop-select2"
            @options[:data] ||= {}
            @options[:data].reverse_merge!(
              allow_clear: true,
              language: I18n.locale
            )
          end

          @collection = @options.delete(:collection)
          @value_method = @options.delete(:value_method)
          @text_method = @options.delete(:text_method)

          @select_config = {}
          @select_config[:include_blank] = @options.delete(:include_blank)
        end

        def default_options
          {
            value_method: :id,
            text_method: :name,
            include_blank: true,
            selected: @object[@method],
            select2: true
          }
        end

      end
    end
  end
end
