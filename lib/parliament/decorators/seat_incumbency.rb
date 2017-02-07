module Parliament
  module Decorators
    module SeatIncumbency
      def start_date
        respond_to?(:seatIncumbencyStartDate) ? seatIncumbencyStartDate : ''
      end

      def end_date
        respond_to?(:seatIncumbencyEndDate) ? seatIncumbencyEndDate : ''
      end

      def seats
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat : []
      end

      def member
        respond_to?(:seatIncumbencyHasMember) ? seatIncumbencyHasMember.first : nil
      end

      def current?
        has_end_date = respond_to?(:seatIncumbencyEndDate)

        !has_end_date
      end
    end
  end
end
