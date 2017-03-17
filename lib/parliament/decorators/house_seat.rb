module Parliament
  module Decorators
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/HouseSeat
    module HouseSeat
      # Alias houseSeatHasHouse with fallback.
      #
      # @return [Grom::Node, nil] the house of the Grom::Node or nil.
      def house
        respond_to?(:houseSeatHasHouse) ? houseSeatHasHouse.first : nil
      end

      # Alias houseSeatHasConstituencyGroup with fallback.
      #
      # @return [Grom::Node, nil] the constituency group of the Grom::Node or nil.
      def constituency
        respond_to?(:houseSeatHasConstituencyGroup) ? houseSeatHasConstituencyGroup.first : nil
      end

      # Alias houseSeatHasSeatIncumbency with fallback.
      #
      # @return [Array, Array] the seat incumbencies of the Grom::Node or an empty.
      def seat_incumbencies
        respond_to?(:houseSeatHasSeatIncumbency) ? houseSeatHasSeatIncumbency : []
      end
    end
  end
end
