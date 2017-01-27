module Parliament
  module Decorators
    module Person
      def houses
        respond_to?(:personHasSitting) ? personHasSitting.first.sittingHasHouse : []
      end
    end
  end
end
