module PopAdmin
  module Forms
    module Inputs
      class InputTag < InputSelect

        def default_options
          super.merge(multiple: 'multiple')
        end
      end
    end
  end
end
