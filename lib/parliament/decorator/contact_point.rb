module Parliament
  module Decorator
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/ContactPoint
    module ContactPoint
      # Alias contactPointHasPostalAddress with fallback.
      #
      # @return [Array, Array] an array of the postal addresses for the Grom::Node or an empty array.
      def postal_addresses
        respond_to?(:contactPointHasPostalAddress) ? contactPointHasPostalAddress : []
      end

      # Alias email with fallback.
      #
      # @return [String, String] the email of the Grom::Node or an empty string.
      def email
        instance_variable_get('@email'.to_sym).nil? ? '' : instance_variable_get('@email'.to_sym)
      end

      # Alias phoneNumber with fallback.
      #
      # @return [String, String] the phone number of the Grom::Node or an empty string.
      def phone_number
        respond_to?(:phoneNumber) ? phoneNumber : ''
      end

      # Alias faxNumber with fallback.
      #
      # @return [String, String] the fax number of the Grom::Node or an empty string.
      def fax_number
        respond_to?(:faxNumber) ? faxNumber : ''
      end

      # Alias contactPointHasPerson with fallback.
      #
      # @return [Array, Array] the person connected to the Grom::Node or an empty array.
      def person
        respond_to?(:contactPointHasPerson) ? contactPointHasPerson : []
      end

      # Alias contactPointHasIncumbency with fallback.
      #
      # @return [Grom::Node, nil] the incumbency of the Grom::Node or nil.
      def incumbency
        respond_to?(:contactPointHasIncumbency) ? contactPointHasIncumbency.first : nil
      end
    end
  end
end
