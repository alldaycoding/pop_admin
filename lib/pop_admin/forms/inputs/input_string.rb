module PopAdmin
  module Forms
    module Inputs
      class InputString

        include Base

        def to_html
          container do
            label +
            field_wrapper do
              @builder.text_field(@method, @options)
            end
          end
        end

      end
    end
  end
end
