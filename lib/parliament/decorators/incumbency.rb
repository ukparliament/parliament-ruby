module Parliament
  module Decorators
    module Incumbency
      def start_date
        respond_to?(:incumbencyStartDate) ? DateTime.parse(incumbencyStartDate) : nil
      end

      def end_date
        respond_to?(:incumbencyEndDate) ? DateTime.parse(incumbencyEndDate) : nil
      end

      def current?
        has_end_date = respond_to?(:incumbencyEndDate)

        !has_end_date
      end

      def member
        respond_to?(:incumbencyHasMember) ? incumbencyHasMember.first : nil
      end

      def contact_points
        respond_to?(:incumbencyHasContactPoint) ? incumbencyHasContactPoint : []
      end

      def seat
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat.first : nil
      end

      def house
        respond_to?(:houseIncumbencyHasHouse) ? houseIncumbencyHasHouse.first : nil
      end
    end
  end
end
