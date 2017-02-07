module Parliament
  module Decorators
    module HouseSeat
      def houses
        respond_to?(:houseSeatHasHouse) ? houseSeatHasHouse : []
      end

      def constituencies
        respond_to?(:houseSeatHasConstituencyGroup) ? houseSeatHasConstituencyGroup : []
      end

      def seat_incumbencies
        respond_to?(:houseSeatHasSeatIncumbency) ? houseSeatHasSeatIncumbency : []
      end
    end
  end
end
