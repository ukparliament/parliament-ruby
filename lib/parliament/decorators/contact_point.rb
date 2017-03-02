module Parliament
  module Decorators
    module ContactPoint
      def postal_addresses
        respond_to?(:contactPointHasPostalAddress) ? contactPointHasPostalAddress : []
      end

      def email
        instance_variable_get('@email'.to_sym).nil? ? '' : instance_variable_get('@email'.to_sym)
      end

      def phone_number
        respond_to?(:phoneNumber) ? phoneNumber : ''
      end

      def fax_number
        respond_to?(:faxNumber) ? faxNumber : ''
      end

      def person
        respond_to?(:contactPointHasPerson) ? contactPointHasPerson : []
      end

      def incumbency
        respond_to?(:contactPointHasIncumbency) ? contactPointHasIncumbency.first : nil
      end
    end
  end
end
