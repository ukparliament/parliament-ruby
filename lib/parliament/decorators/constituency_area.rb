module Parliament
  module Decorators
    module ConstituencyArea
      def latitude
        respond_to?(:constituencyAreaLatitude) ? constituencyAreaLatitude : ''
      end

      def longitude
        respond_to?(:constituencyAreaLongitude) ? constituencyAreaLongitude : ''
      end

      def polygon
        respond_to?(:constituencyAreaExtent) ? constituencyAreaExtent : ''
      end
    end
  end
end
