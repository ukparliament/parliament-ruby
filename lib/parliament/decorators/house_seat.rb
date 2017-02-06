module Parliament
  module Decorators
    module HouseSeat
      def houses
        respond_to?(:houseSeatHasHouse) ? houseSeatHasHouse : []
      end
    end
  end
end