module Parliament
  module Decorators
    module SeatIncumbency
      def start_date
        respond_to?(:seatIncumbencyStartDate) ? DateTime.parse(seatIncumbencyStartDate) : nil
      end

      def end_date
        respond_to?(:seatIncumbencyEndDate) ? DateTime.parse(seatIncumbencyEndDate) : nil
      end

      def seat
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat.first : nil
      end

      def current?
        has_end_date = respond_to?(:incumbencyEndDate)

        !has_end_date
      end

      def house
        seat.nil? ? nil : seat.house
      end

      def constituency
        seat.nil? ? nil : seat.constituency
      end

      def contact_points
        respond_to?(:incumbencyHasContactPoint) ? incumbencyHasContactPoint : []
      end

      def member
        respond_to?(:incumbencyHasMember) ? incumbencyHasMember.first : nil
      end
    end
  end
end
