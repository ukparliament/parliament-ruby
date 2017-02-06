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
    end
  end
end
