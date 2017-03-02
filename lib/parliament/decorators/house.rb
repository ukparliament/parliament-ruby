module Parliament
  module Decorators
    module House
      def name
        respond_to?(:houseName) ? houseName : ''
      end

      def seat_incumbencies
        return @seat_incumbencies unless @seat_incumbencies.nil?

        seat_incumbencies = []
        seats.each do |seat|
          seat_incumbencies << seat.seat_incumbencies
        end

        @seat_incumbencies = seat_incumbencies.flatten.uniq
      end

      def seats
        respond_to?(:houseHasHouseSeat) ? houseHasHouseSeat : []
      end

      def house_incumbencies
        respond_to?(:houseHasHouseIncumbency) ? houseHasHouseIncumbency : []
      end
    end
  end
end
