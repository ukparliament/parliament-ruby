module Parliament
  module Decorators
    module Person
      def houses
        respond_to?(:sittings) ? sittings.first.houses : []
      end
    end
  end
end
