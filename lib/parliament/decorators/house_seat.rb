module Parliament
  module Decorators
    module HouseSeat
      def house
        respond_to?(:houseSeatHasHouse) ? houseSeatHasHouse.first : nil
      end

      def constituency
        respond_to?(:houseSeatHasConstituencyGroup) ? houseSeatHasConstituencyGroup.first : nil
      end

      def seat_incumbencies
        respond_to?(:houseSeatHasSeatIncumbency) ? houseSeatHasSeatIncumbency : []
      end
    end
  end
end
