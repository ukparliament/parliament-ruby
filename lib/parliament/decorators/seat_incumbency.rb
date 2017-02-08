module Parliament
  module Decorators
    module SeatIncumbency
      def start_date
        respond_to?(:seatIncumbencyStartDate) ? seatIncumbencyStartDate : ''
      end

      def end_date
        respond_to?(:seatIncumbencyEndDate) ? seatIncumbencyEndDate : ''
      end

      def seat
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat.first : nil
      end

      def member
        respond_to?(:seatIncumbencyHasMember) ? seatIncumbencyHasMember.first : nil
      end

      def current?
        has_end_date = respond_to?(:seatIncumbencyEndDate)

        !has_end_date
      end

      def house
        seat.nil? ? nil : seat.house
      end

      def constituency
        seat.nil? ? nil : seat.constituency
      end

      def contact_points
        respond_to?(:seatIncumbencyHasContactPoint) ? seatIncumbencyHasContactPoint : []
      end
    end
  end
end
