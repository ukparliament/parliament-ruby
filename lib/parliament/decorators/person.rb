module Parliament
  module Decorators
    module Person
      def given_name
        respond_to?(:personGivenName) ? personGivenName : ''
      end

      def family_name
        respond_to?(:personFamilyName) ? personFamilyName : ''
      end

      def other_name
        respond_to?(:personOtherNames) ? personOtherNames : ''
      end

      def date_of_birth
        respond_to?(:personDateOfBirth) ? DateTime.parse(personDateOfBirth) : nil
      end

      def full_name
        full_name = ''
        full_name += respond_to?(:personGivenName) ? personGivenName + ' ' : ''
        full_name += respond_to?(:personFamilyName) ? personFamilyName : ''
        full_name.rstrip
      end

      def incumbencies
        respond_to?(:memberHasIncumbency) ? memberHasIncumbency : []
      end

      def seat_incumbencies
        respond_to?(:memberHasIncumbency) ? memberHasIncumbency : []
      end

      def seats
        return @seats unless @seats.nil?

        seats = []
        seat_incumbencies.each do |incumbency|
          seats << incumbency.seat if incumbency.respond_to?(:seat)
        end

        @seats = seats.flatten.uniq
      end

      def houses
        return @houses unless @houses.nil?

        houses = []
        seats.each do |seat|
          houses << seat.house
        end

        @houses = houses.flatten.uniq
      end

      def constituencies
        return @constituencies unless @constituencies.nil?

        constituencies = []
        seats.each do |seat|
          constituencies << seat.constituency
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
          parties << party_membership.party
        end

        @parties = parties.flatten.uniq.compact
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
