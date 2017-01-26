module Parliament
  module Decorator
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/Gender
    module Gender
      # Alias genderName with fallback.
      #
      # @return [String, String] the gender name of the Grom::Node or an empty string.
      def name
        respond_to?(:genderName) ? genderName : ''
      end
    end
  end
end
