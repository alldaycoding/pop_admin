module PopAdmin
  module Forms
    module Inputs
      class InputPassword

        include Base

        def to_html
          container do
            label +
            field_wrapper do
              @builder.password_field(@method, @options)
            end
          end
        end

      end
    end
  end
end
