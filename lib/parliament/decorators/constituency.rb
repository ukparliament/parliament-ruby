module Parliament
  module Decorators
    module Constituency
      def name
        respond_to?(:constituencyGroupName) ? constituencyGroupName : ''
      end
      #
      # def sittings
      #   respond_to?(:personHasSitting) ? personHasSitting : []
      # end
    end
  end
end
