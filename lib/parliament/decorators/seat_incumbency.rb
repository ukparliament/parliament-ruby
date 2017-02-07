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

      def members
        respond_to?(:seatIncumbencyHasMember) ? seatIncumbencyHasMember : []
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
    end
  end
end
