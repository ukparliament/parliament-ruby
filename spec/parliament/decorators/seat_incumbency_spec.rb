require_relative '../../spec_helper'

describe Parliament::Decorators::SeatIncumbency, vcr: true do
  let(:response) { Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get }

  before(:each) do
    @seat_incumbency_nodes = response.filter('http://id.ukpds.org/schema/SeatIncumbency').first
  end

  describe '#start_date' do
    context 'seat incumbency has a start date' do
      it 'returns the start date of the seat incumbency' do
        seat_incumbency_node = @seat_incumbency_nodes.first

        expect(seat_incumbency_node).to respond_to(:start_date)
        expect(seat_incumbency_node.start_date).to eq '1992-04-09'
      end
    end

    context 'seat incumbency has no start date' do
      it 'returns an empty string' do
        seat_incumbency_node = @seat_incumbency_nodes[1]

        expect(seat_incumbency_node).to respond_to(:start_date)
        expect(seat_incumbency_node.start_date).to eq ''
      end
    end
  end

  describe '#end_date' do
    context 'seat incumbency has an end date' do
      it 'returns the end date of the seat incumbency' do
        seat_incumbency_node = @seat_incumbency_nodes.first

        expect(seat_incumbency_node).to respond_to(:end_date)
        expect(seat_incumbency_node.end_date).to eq '1997-05-01'
      end
    end

    context 'seat incumbency has no end date' do
      it 'returns an empty string' do
        seat_incumbency_node = @seat_incumbency_nodes[1]

        expect(seat_incumbency_node).to respond_to(:end_date)
        expect(seat_incumbency_node.end_date).to eq ''
      end
    end
  end

  describe '#seats' do
    context 'Grom::Node has all the required objects' do
      it 'returns the seats for a Grom::Node object of type SeatIncumbency' do
        seat_incumbency_node = @seat_incumbency_nodes.first

        expect(seat_incumbency_node.seats.size).to eq(1)
        expect(seat_incumbency_node.seats.first.type).to eq('http://id.ukpds.org/schema/HouseSeat')
      end
    end

    context 'Grom::Node has no seats' do
      it 'returns an empty array' do
        seat_incumbency_node = @seat_incumbency_nodes[1]

        expect(seat_incumbency_node.seats).to eq([])
      end
    end
  end

  describe '#members' do
    context 'Grom::Node has all the required objects' do
      it 'returns the members for a Grom::Node object of type SeatIncumbency' do
        seat_incumbency_node = @seat_incumbency_nodes.first

        expect(seat_incumbency_node.members.size).to eq(1)
        expect(seat_incumbency_node.members.first.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    context 'Grom::Node has no members' do
      it 'returns an empty array' do
        seat_incumbency_node = @seat_incumbency_nodes[1]

        expect(seat_incumbency_node.members).to eq([])
      end
    end
  end

  describe '#current?' do
    it 'Grom::Node returns the correct value for a current or non current seat incumbency' do
      seat_incumbency_results = @seat_incumbency_nodes.map(&:current?)

      expect(seat_incumbency_results).to eq([true, false, false, false, false])
    end
  end
end
