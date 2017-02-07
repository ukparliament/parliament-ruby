module Parliament
  module Decorators
    module SeatIncumbency
      def seats
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat : []
      end

      def current?
        has_end_date = respond_to?(:seatIncumbencyEndDate)

        !has_end_date
      end
    end
  end
end
