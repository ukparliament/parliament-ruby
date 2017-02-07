module Parliament
  module Decorators
    module PartyMembership
      def parties
        respond_to?(:partyMembershipHasParty) ? partyMembershipHasParty : []
      end

      def start_date
        respond_to?(:partyMembershipStartDate) ? partyMembershipStartDate : ''
      end

      def end_date
        respond_to?(:partyMembershipEndDate) ? partyMembershipEndDate : ''
      end
    end
  end
end
