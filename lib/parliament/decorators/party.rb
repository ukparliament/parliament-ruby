
module Parliament
  module Decorators
    module Party
      def name
        respond_to?(:partyName) ? partyName : ''
      end

      def party_membership
        respond_to?(:partyHasPartyMembership) ? partyHasPartyMembership : []
      end
    end
  end
end
