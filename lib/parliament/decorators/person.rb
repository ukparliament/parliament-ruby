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
        if respond_to?(:memberHasIncumbency)
          memberHasIncumbency.select { |inc| inc.type == 'http://id.ukpds.org/schema/SeatIncumbency' }
        else
          []
        end
      end

      def house_incumbencies
        if respond_to?(:memberHasIncumbency)
          memberHasIncumbency.select { |inc| inc.type == 'http://id.ukpds.org/schema/HouseIncumbency' }
        else
          []
        end
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

        house_incumbencies.each do |inc|
          houses << inc.house
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

      def statuses
        return @statuses unless @statuses.nil?

        statuses = {}
        statuses[:house_membership_status] = house_membership_status
        statuses[:general_membership_status] = general_membership_status

        @statuses = statuses
      end

      def full_title
        respond_to?(:D79B0BAC513C4A9A87C9D5AFF1FC632F) ? self.D79B0BAC513C4A9A87C9D5AFF1FC632F : ''
      end

      def display_name
        respond_to?(:F31CBD81AD8343898B49DC65743F0BDF) ? self.F31CBD81AD8343898B49DC65743F0BDF : ''
      end

      private

      def house_membership_status
        statuses = []
        statuses << 'Current MP' unless seat_incumbencies.select(&:current?).empty?
        statuses << 'Lord' unless house_incumbencies.select(&:current?).empty?
        statuses << 'Former Lord' if !house_incumbencies.empty? && house_incumbencies.select(&:current?).empty?
        statuses << 'Former MP' if !seat_incumbencies.empty? && seat_incumbencies.select(&:current?).empty?
        statuses
      end

      def general_membership_status
        statuses = []
        statuses << 'Current Member' unless incumbencies.select(&:current?).empty?
        statuses << 'Former Member' if !incumbencies.empty? && incumbencies.select(&:current?).empty?
        statuses
      end
    end
  end
end
