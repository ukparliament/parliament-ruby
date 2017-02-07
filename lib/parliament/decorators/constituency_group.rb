module Parliament
  module Decorators
    module ConstituencyGroup
      def name
        respond_to?(:constituencyGroupName) ? constituencyGroupName : ''
      end

      def start_date
        respond_to?(:constituencyGroupStartDate) ? constituencyGroupStartDate : ''
      end

      def end_date
        respond_to?(:constituencyGroupEndDate) ? constituencyGroupEndDate : ''
      end

      def seats
        respond_to?(:constituencyGroupHasHouseSeat) ? constituencyGroupHasHouseSeat : []
      end

      def seat_incumbencies
        return @seat_incumbencies unless @seat_incumbencies .nil?

        seat_incumbencies = []
        seats.each do |seat|
          seat_incumbencies << seat.seat_incumbencies
        end

        @seat_incumbencies = seat_incumbencies.flatten.uniq
      end

      def members
        return @members unless @members .nil?

        members = []
        seat_incumbencies.each do |seat_incumbency|
          members << seat_incumbency.members
        end

        @members = members.flatten.uniq
      end
    end
  end
end
