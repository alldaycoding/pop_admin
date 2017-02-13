module PopAdmin
  module Forms
    module Inputs
      class InputCheck

        include Base

        def to_html
          lbl = @options.delete(:label) || I18n.ta(@object, @method)
          container do
            field_wrapper do
              @template.content_tag('label') do
                @builder.check_box(@method, @options) +
                lbl
              end
            end
          end
        end

        def field_wrapper_style
          if horizontal?
            "#{super} checkbox col-sm-offset-#{grid[0]}"
          else
            "#{super} checkbox"
          end
        end

      end
    end
  end
end
