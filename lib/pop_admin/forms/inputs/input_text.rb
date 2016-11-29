module PopAdmin
  module Forms
    module Inputs
      class InputText

        include Base

        def to_html
          container do
            label +
            field_wrapper do
              @builder.text_area(@method, @options)
            end
          end
        end

      end
    end
  end
end
