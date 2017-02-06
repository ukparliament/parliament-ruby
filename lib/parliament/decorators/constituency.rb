module Parliament
  module Decorators
    module Constituency
      def name
        respond_to?(:constituencyGroupName) ? constituencyGroupName : ''
      end

      def start_date
        respond_to?(:constituencyGroupStartDate) ? constituencyGroupStartDate : ''
      end

      def end_date
        respond_to?(:constituencyGroupEndDate) ? constituencyGroupEndDate : ''
      end
    end
  end
end
