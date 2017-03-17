module Parliament
  module Decorators
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/GenderIdentity
    module GenderIdentity
      # Alias genderIdentityHasGender with fallback.
      #
      # @return [Grom::Node, nil] a Grom::Node with type http://id.ukpds.org/schema/Gender or nil.
      def gender
        respond_to?(:genderIdentityHasGender) ? genderIdentityHasGender.first : nil
      end
    end
  end
end
