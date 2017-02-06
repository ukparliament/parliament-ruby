module Parliament
  module Decorators
    module Constituency
      def name
        respond_to?(:constituencyGroupName) ? constituencyGroupName : ''
      end
    end
  end
end
