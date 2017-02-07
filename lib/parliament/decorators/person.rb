module Parliament
  module Decorators
    module Person
      def given_name
        respond_to?(:personGivenName) ? personGivenName : ''
      end

      def family_name
        respond_to?(:personFamilyName) ? personFamilyName : ''
      end

      def full_name
        full_name = ''
        full_name += respond_to?(:personGivenName) ? personGivenName + ' ' : ''
        full_name += respond_to?(:personFamilyName) ? personFamilyName : ''
        full_name.rstrip
      end

      def seat_incumbencies
        respond_to?(:memberHasSeatIncumbency) ? memberHasSeatIncumbency : []
      end

      def seats
        return @seats unless @seats.nil?

        seats = []
        seat_incumbencies.each do |seat_incumbency|
          seats << seat_incumbency.seats
        end

        @seats = seats.flatten.uniq
      end

      def houses
        return @houses unless @houses.nil?

        houses = []
        seats.each do |seat|
          houses << seat.houses
        end

        @houses = houses.flatten.uniq
      end

      def constituencies
        return @constituencies unless @constituencies.nil?

        constituencies = []
        seats.each do |seat|
          constituencies << seat.constituencies
        end

        @constituencies = constituencies.flatten.uniq
      end

      def party_memberships
        respond_to?(:partyMemberHasPartyMembership) ? partyMemberHasPartyMembership : []
      end

      def parties
        return @parties unless @parties.nil?

        parties = []
        party_memberships.each do |party_membership|
          parties << party_membership.parties
        end

        @parties = parties.flatten.uniq
      end

      def contact_points
        respond_to?(:personHasContactPoint) ? personHasContactPoint : []
      end

      def gender_identities
        respond_to?(:personHasGenderIdentity) ? personHasGenderIdentity : []
      end

      def gender
        gender_identities.empty? ? nil : gender_identities.first.gender
      end
    end
  end
end
