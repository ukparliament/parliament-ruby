require_relative '../../spec_helper'

describe Parliament::Decorators::PartyMembership, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get
  end

  before(:each) do
    @party_membership_nodes = response.filter('http://id.ukpds.org/schema/PartyMembership').first
  end

  describe '#party' do
    context 'Grom::Node has all the required objects' do
      it 'returns the party for a Grom::Node object of type PartyMembership' do
        party_membership_node = @party_membership_nodes.first

        expect(party_membership_node.party.name).to eq('Labour')
        expect(party_membership_node.party.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    context 'Grom::Node has no parties' do
      it 'returns an empty array' do
        party_membership_node = @party_membership_nodes[1]
        p party_membership_node

        expect(party_membership_node.party).to be(nil)
      end
    end
  end

  describe '#start_date' do
    context 'Grom::Node has all the required objects' do
      it 'returns the start date for a Grom::Node object of type PartyMembership' do
        party_membership_node = @party_membership_nodes.first

        expect(party_membership_node.start_date).to eq('1992-04-09')
      end
    end

    context 'Grom::Node has no start date' do
      it 'returns an empty string' do
        party_membership_node = @party_membership_nodes[1]

        expect(party_membership_node.start_date).to eq('')
      end
    end
  end

  describe '#end_date' do
    context 'Grom::Node has all the required objects' do
      it 'returns the end date for a Grom::Node object of type PartyMembership' do
        party_membership_node = @party_membership_nodes.first

        expect(party_membership_node.end_date).to eq('2015-03-30')
      end
    end

    context 'Grom::Node has no end date' do
      it 'returns an empty string' do
        party_membership_node = @party_membership_nodes[1]

        expect(party_membership_node.end_date).to eq('')
      end
    end
  end
end
