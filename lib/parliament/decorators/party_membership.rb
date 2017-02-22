module Parliament
  module Decorators
    module PartyMembership
      def party
        respond_to?(:partyMembershipHasParty) ? partyMembershipHasParty.first : nil
      end

      def start_date
        respond_to?(:partyMembershipStartDate) ? DateTime.parse(partyMembershipStartDate) : nil
      end

      def end_date
        respond_to?(:partyMembershipEndDate) ? DateTime.parse(partyMembershipEndDate) : nil
      end

      def current?
        has_end_date = respond_to?(:partyMembershipEndDate)

        !has_end_date
        
        respond_to?(:partyMembershipStartDate) ? Time.parse(partyMembershipStartDate) : nil
      end
    end
  end
end
