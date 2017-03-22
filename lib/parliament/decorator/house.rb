module Parliament
  module Decorator
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/House
    module House
      # Alias houseName with fallback.
      #
      # @return [String, String] the name of the Grom::Node or an empty string.
      def name
        respond_to?(:houseName) ? houseName : ''
      end

      # Alias houseSeatHasSeatIncumbency with fallback.
      #
      # @return [Array, Array] the seat incumbencies of the Grom::Node or an empty array.
      def seat_incumbencies
        return @seat_incumbencies unless @seat_incumbencies.nil?

        seat_incumbencies = []
        seats.each do |seat|
          seat_incumbencies << seat.seat_incumbencies
        end

        @seat_incumbencies = seat_incumbencies.flatten.uniq
      end

      # Alias houseHasHouseSeat with fallback.
      #
      # @return [Array, Array] the house seats of the Grom::Node or an empty array.
      def seats
        respond_to?(:houseHasHouseSeat) ? houseHasHouseSeat : []
      end

      # Alias houseHasHouseIncumbency with fallback.
      #
      # @return [Array, Array] the house incumbencies of the Grom::Node or an empty array.
      def house_incumbencies
        respond_to?(:houseHasHouseIncumbency) ? houseHasHouseIncumbency : []
      end
    end
  end
end
