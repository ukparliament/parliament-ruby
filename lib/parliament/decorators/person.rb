module Parliament
  module Decorators
    module Person
      def houses
        respond_to?(:personHasSitting) ? personHasSitting.first.sittingHasHouse : []
      end

      def sittings
        respond_to?(:personHasSitting) ? personHasSitting : []
      end

      def given_name
        respond_to?(:personGivenName) ? personGivenName : ''
      end

      def family_name
        respond_to?(:personFamilyName) ? personFamilyName : ''
      end
    end
  end
end
