module PopAdmin
  module Forms
    module Inputs
      class InputDate

        include Base

        def to_html
          container do
            label +
            field_wrapper do
              input_group_wrapper do
                @builder.text_field(@method, @options)
              end
            end
          end
        end

        def field_style
          "#{@options[:class]} form-control datepicker"
        end

        def input_group_wrapper
          @template.content_tag('div', class: 'input-group') do
            yield +
            @template.content_tag('div', class: 'input-group-addon') do
              @template.link_to("#") do
                @template.content_tag("i", "", class: 'entypo-calendar')
              end
            end
          end
        end

      end
    end
  end
end
