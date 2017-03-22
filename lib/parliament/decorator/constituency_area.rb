module Parliament
  module Decorator
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/ConstituencyArea
    module ConstituencyArea
      # Alias constituencyAreaLatitude with fallback.
      #
      # @return [String, String] the latitude of the Grom::Node or an empty string.
      def latitude
        respond_to?(:constituencyAreaLatitude) ? constituencyAreaLatitude : ''
      end

      # Alias constituencyAreaLongitude with fallback.
      #
      # @return [String, String] the longitude of the Grom::Node or an empty string.
      def longitude
        respond_to?(:constituencyAreaLongitude) ? constituencyAreaLongitude : ''
      end

      # Alias constituencyAreaExtent with fallback.
      #
      # @return [String, String] the polygon of the Grom::Node or an empty string.
      def polygon
        respond_to?(:constituencyAreaExtent) ? constituencyAreaExtent : ''
      end
    end
  end
end
