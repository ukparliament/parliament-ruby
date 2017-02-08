module Parliament
  module Decorators
    module ContactPoint
      def postal_addresses
        respond_to?(:contactPointHasPostalAddress) ? contactPointHasPostalAddress : []
      end
    end
  end
end
