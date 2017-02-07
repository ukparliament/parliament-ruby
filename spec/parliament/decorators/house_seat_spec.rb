require_relative '../../spec_helper'

describe Parliament::Decorators::HouseSeat, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get
  end

  before(:each) do
    @seat_nodes = response.filter('http://id.ukpds.org/schema/HouseSeat').first
  end

  describe '#house' do
    context 'Grom::Node has all the required objects' do
      it 'returns the house for a Grom::Node object of type HouseSeat' do
        seat_node = @seat_nodes.first

        expect(seat_node.house.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context 'Grom::Node has no house' do
      it 'returns nil' do
        seat_node = @seat_nodes[1]

        expect(seat_node.house).to be(nil)
      end
    end
  end

  describe '#constituency' do
    context 'Grom::Node has all the required objects' do
      it 'returns the constituency for a Grom::Node object of type HouseSeat' do
        seat_node = @seat_nodes.first

        expect(seat_node.constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    context 'Grom::Node has no constituency' do
      it 'returns nil' do
        seat_node = @seat_nodes[1]

        expect(seat_node.constituency).to be(nil)
      end
    end
  end

  describe '#seat_incumbencies' do
    before(:each) do
      @seat_nodes = response.filter('http://id.ukpds.org/schema/HouseSeat').first
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the seat incumbencies for a Grom::Node object of type HouseSeat' do
        seat_node = @seat_nodes.first

        expect(seat_node.seat_incumbencies.size).to eq(1)
        expect(seat_node.seat_incumbencies.first.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end
    end

    context 'Grom::Node has no seat incumbencies' do
      it 'returns an empty array' do
        seat_node = @seat_nodes[1]

        expect(seat_node.seat_incumbencies).to eq([])
      end
    end
  end
end
