module Parliament
  module Decorators
    module PostalAddress
      def full_address
        address_array.join('</br>')
      end

      private

      def address_array
        address_array = []
        for i in 1..5
          if (respond_to?("addressLine#{i.to_s}".to_sym))
            address_array << instance_variable_get("@addressLine#{i.to_s}".to_sym)
          end
        end
        if respond_to?(:postCode)
          address_array << postCode
        end
        address_array
      end
    end
  end
end
