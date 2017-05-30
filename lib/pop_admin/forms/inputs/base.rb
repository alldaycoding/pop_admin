module PopAdmin
  module Forms
    module Inputs
      module Base

        def initialize(builder, template, object, object_name, method, options)
          @builder = builder
          @template = template
          @object = object
          @object_name = object_name
          @method = method
          @options = options.dup
          @options.reverse_merge!(
            form_type: @builder.form_type
          )
          @options[:class] = field_style
        end

        def to_html
          raise NotImplementedError
        end

        def container
          @template.content_tag('div', class: container_style) do
            yield
          end
        end

        def container_style
          errors.any? ? 'form-group has-error' : 'form-group'
        end

        def field_wrapper
          @template.content_tag('div', class: field_wrapper_style) do
            @template.concat(yield)
            @template.concat(error_messages) if errors.any?
          end
        end

        def label
          label = @options.delete(:label)
          if (label || label.nil?) && (!clean?)
            @builder.label(@method, label, class: label_style)
          else
            "".html_safe
          end
        end

        [:horizontal, :vertical, :clean].each do |ftype|
          define_method("#{ftype}?") do
            @options[:form_type].to_sym == ftype
          end
        end

        def label_style
          @builder.horizontal? ? "col-sm-#{grid[0]} control-label" : "control-label"
        end

        def field_wrapper_style
          @builder.horizontal? ? "col-sm-#{grid[1]} control-wrapper" : "control-wrapper"
        end

        def field_style
          "#{@options[:class]} form-control"
        end

        def grid
          return @grid if @grid

          grid_def = @options.delete(:grid) || "4x8"
          @grid = grid_def.strip.split("x")
        end

        def errors
          @errors ||= @object.errors[@method]
        end

        def error_messages
          @template.content_tag :p, :class => 'help-block' do
            messages = errors.map do |err|
              err.to_s.capitalize
            end
            messages[0]
          end
        end

      end
    end
  end
end
