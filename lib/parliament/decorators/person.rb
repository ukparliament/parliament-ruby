module Parliament
  module Decorators
    module Person
      def houses
        respond_to?(:personHasSitting) ? personHasSitting.first.sittingHasHouse : []
      end

      def sittings
        respond_to?(:personHasSitting) ? personHasSitting : []
      end
    end
  end
end
