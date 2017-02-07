module Parliament
  module Decorators
    module HouseSeat
      def houses
        respond_to?(:houseSeatHasHouse) ? houseSeatHasHouse : []
      end

      def constituencies
        respond_to?(:houseSeatHasConstituencyGroup) ? houseSeatHasConstituencyGroup : []
      end
    end
  end
end
