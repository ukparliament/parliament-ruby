module Parliament
  module Decorators
    module House
      def name
        respond_to?(:houseName) ? houseName : ''
      end
    end
  end
end
