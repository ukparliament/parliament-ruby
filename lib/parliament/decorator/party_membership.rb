module Parliament
  module Decorator
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/PartyMembership
    module PartyMembership
      # Alias partyMembershipHasParty with fallback.
      #
      # @return [Grom::Node, nil] the party of the Grom::Node or nil.
      def party
        respond_to?(:partyMembershipHasParty) ? partyMembershipHasParty.first : nil
      end

      # Alias partyMembershipStartDate with fallback.
      #
      # @return [DateTime, nil] the start date of the Grom::Node or nil.
      def start_date
        @start_date ||= respond_to?(:partyMembershipStartDate) ? DateTime.parse(partyMembershipStartDate) : nil
      end

      # Alias partyMembershipEndDate with fallback.
      #
      # @return [DateTime, nil] the end date of the Grom::Node or nil.
      def end_date
        @end_date ||= respond_to?(:partyMembershipEndDate) ? DateTime.parse(partyMembershipEndDate) : nil
      end

      # Checks if Grom::Node has an end date.
      #
      # @return [Boolean] a boolean depending on whether or not the Grom::Node has an end date.
      def current?
        end_date.nil?
      end
    end
  end
end
