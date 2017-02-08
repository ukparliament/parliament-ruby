module Parliament
  module Decorators
    module GenderIdentity
      def gender
        respond_to?(:genderIdentityHasGender) ? genderIdentityHasGender.first : nil
      end
    end
  end
end
