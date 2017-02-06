module Parliament
  module Decorators
    module SeatIncumbency
      def seats
        respond_to?(:seatIncumbencyHasHouseSeat) ? seatIncumbencyHasHouseSeat : []
      end
    end
  end
end
