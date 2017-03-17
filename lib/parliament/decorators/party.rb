module Parliament
  module Decorators
    # Decorator namespace for Grom::Node instances with type: http://id.ukpds.org/schema/Party
    module Party
      # Alias partyName with fallback.
      #
      # @return [String, String] the party name of the Grom::Node or an empty string.
      def name
        respond_to?(:partyName) ? partyName : ''
      end

      # Alias partyHasPartyMembership with fallback.
      #
      # @return [Array, Array] the party memberships of the Grom::Node or an empty array.
      def party_memberships
        respond_to?(:partyHasPartyMembership) ? partyHasPartyMembership : []
      end

      # Alias count with fallback.
      #
      # @return [Integer, nil] the count of members of the Grom::Node or nil.
      def member_count
        respond_to?(:count) ? count.to_i : nil
      end
    end
  end
end
