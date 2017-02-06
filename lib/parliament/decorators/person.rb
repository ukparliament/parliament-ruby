module Parliament
  module Decorators
    module Person
      def seat_incumbencies
        respond_to?(:memberHasSeatIncumbency) ? memberHasSeatIncumbency : []
      end

      def seats
        return @seats unless @seats.nil?

        seats = []
        seat_incumbencies.each do |seat_incumbency|
          seats << seat_incumbency.seats
        end

        @seats = seats.flatten
      end

      def houses
        return @houses unless @houses.nil?

        houses = []
        seats.each do |seat|
          houses << seat.houses
        end

        @houses = houses.flatten
      end

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

      def parties
        respond_to?(:partyMemberHasPartyMembership) ? partyMemberHasPartyMembership.first.partyMembershipHasParty : []
      end
    end
  end
end
