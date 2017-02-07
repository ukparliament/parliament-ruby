require_relative '../../spec_helper'

describe Parliament::Decorators::HouseSeat, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get
  end

  before(:each) do
    @seat_nodes = response.filter('http://id.ukpds.org/schema/HouseSeat').first
  end

  describe '#houses' do
    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node object of type HouseSeat' do
        seat_node = @seat_nodes.first

        expect(seat_node.houses.size).to eq(1)
        expect(seat_node.houses.first.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context 'Grom::Node has no houses' do
      it 'returns an empty array' do
        seat_node = @seat_nodes[1]

        expect(seat_node.houses).to eq([])
      end
    end
  end

  describe '#constituencies' do
    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node object of type ConstituencyGroup' do
        seat_node = @seat_nodes.first

        expect(seat_node.constituencies.size).to eq(1)
        expect(seat_node.constituencies.first.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    context 'Grom::Node has no constituencies' do
      it 'returns an empty array' do
        seat_node = @seat_nodes[1]

        expect(seat_node.constituencies).to eq([])
      end
    end
  end
end
