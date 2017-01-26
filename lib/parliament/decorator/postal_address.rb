module Parliament
  module Decorator
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/PostalAddress
    module PostalAddress
      # Builds a full address using the lines of the address and the postcode.
      #
      # @return [String, String] the full address of the Grom::Node or an empty string.
      def full_address
        address_array.join(', ')
      end

      private

      def address_array
        address_array = []
        (1..5).each do |i|
          if respond_to?("addressLine#{i}".to_sym)
            address_array << instance_variable_get("@addressLine#{i}".to_sym)
          end
        end
        address_array << postCode if respond_to?(:postCode)
        address_array
      end
    end
  end
end
