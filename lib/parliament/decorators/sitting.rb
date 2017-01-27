module Parliament
  module Decorators
    module Sitting
      def houses
        respond_to?(:sittingHasHouse) ? sittingHasHouse : []
      end
    end
  end
end