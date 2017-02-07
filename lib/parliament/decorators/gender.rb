module Parliament
  module Decorators
    module Gender
      def name
        respond_to?(:genderName) ? genderName : ''
      end
    end
  end
end
