module Parliament
  module Decorators
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/Incumbency
    module Incumbency
      # Alias incumbencyStartDate with fallback.
      #
      # @return [DateTime, nil] the start date of the Grom::Node or nil.
      def start_date
        respond_to?(:incumbencyStartDate) ? DateTime.parse(incumbencyStartDate) : nil
      end

      # Alias incumbencyEndDate with fallback.
      #
      # @return [DateTime, nil] the end date of the Grom::Node or nil.
      def end_date
        respond_to?(:incumbencyEndDate) ? DateTime.parse(incumbencyEndDate) : nil
      end

      # Checks if Grom::Node has an end date.
      #
      # @return [Boolean] a boolean depending on whether or not the Grom::Node has an end date.
      def current?
        has_end_date = respond_to?(:incumbencyEndDate)

        !has_end_date
      end

      # Alias incumbencyHasMember with fallback.
      #
      # @return [Grom::Node, nil] the member connected to the Grom::Node or nil.
      def member
        respond_to?(:incumbencyHasMember) ? incumbencyHasMember.first : nil
      end

      # Alias incumbencyHasContactPoint with fallback.
      #
      # @return [Array, Array] the contact points of the Grom::Node or an empty array.
      def contact_points
        respond_to?(:incumbencyHasContactPoint) ? incumbencyHasContactPoint : []
      end

      # Alias seatIncumbencyHasHouseSeat with fallback.
      #
      # @return [Grom::Node, nil] the seat of the Grom::Node or nil.
      def seat
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat.first : nil
      end

      # Alias houseIncumbencyHasHouse with fallback.
      #
      # @return [Grom::Node, nil] the house of the Grom::Node or nil.
      def house
        respond_to?(:houseIncumbencyHasHouse) ? houseIncumbencyHasHouse.first : nil
      end
    end
  end
end
