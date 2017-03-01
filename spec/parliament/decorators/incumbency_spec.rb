require_relative '../../spec_helper'

describe Parliament::Decorators::Incumbency, vcr: true do
  let(:id) { '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').houses(id).members.current.get
  end

  before(:each) do
    @incumbency_nodes = response.filter('http://id.ukpds.org/schema/Incumbency')
  end

  describe '#start_date' do
    context 'incumbency has a start date' do
      it 'returns the start date of the incumbency' do
        incumbency_node = @incumbency_nodes.first

        expect(incumbency_node).to respond_to(:start_date)
        expect(incumbency_node.start_date).to eq(DateTime.new(2015, 5, 7))
      end
    end

    context 'incumbency has no start date' do
      it 'returns nil' do
        incumbency_node = @incumbency_nodes[1]

        expect(incumbency_node).to respond_to(:start_date)
        expect(incumbency_node.start_date).to be(nil)
      end
    end
  end

  describe '#end_date' do
    context 'incumbency has an end date' do
      it 'returns the end date of the incumbency' do
        incumbency_node = @incumbency_nodes.first

        expect(incumbency_node).to respond_to(:end_date)
        expect(incumbency_node.end_date).to eq(DateTime.new(2016, 5, 7))
      end
    end

    context 'incumbency has no end date' do
      it 'returns nil' do
        incumbency_node = @incumbency_nodes[1]

        expect(incumbency_node).to respond_to(:end_date)
        expect(incumbency_node.end_date).to be(nil)
      end
    end
  end

  # describe '#seat' do
  #   context 'Grom::Node has all the required objects' do
  #     it 'returns the seat for a Grom::Node object of type SeatIncumbency' do
  #       seat_incumbency_node = @seat_incumbency_nodes.first
  #
  #       expect(seat_incumbency_node.seat.type).to eq('http://id.ukpds.org/schema/HouseSeat')
  #     end
  #   end
  #
  #   context 'Grom::Node has no seats' do
  #     it 'returns an empty array' do
  #       seat_incumbency_node = @seat_incumbency_nodes[1]
  #
  #       expect(seat_incumbency_node.seat).to be(nil)
  #     end
  #   end
  # end
  #
  # describe '#house' do
  #   context 'Grom::Node has all the required objects' do
  #     it 'returns the house for a Grom::Node object of type SeatIncumbency' do
  #       seat_incumbency_node = @seat_incumbency_nodes.first
  #
  #       expect(seat_incumbency_node.house.type).to eq('http://id.ukpds.org/schema/House')
  #     end
  #   end
  #
  #   context 'Grom::Node has no house' do
  #     it 'returns nil' do
  #       seat_incumbency_node = @seat_incumbency_nodes[1]
  #
  #       expect(seat_incumbency_node.house).to be(nil)
  #     end
  #   end
  # end
  #
  # describe '#constituency' do
  #   context 'Grom::Node has all the required objects' do
  #     it 'returns the constituency for a Grom::Node object of type SeatIncumbency' do
  #       seat_incumbency_node = @seat_incumbency_nodes.first
  #
  #       expect(seat_incumbency_node.constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
  #     end
  #   end
  #
  #   context 'Grom::Node has no constituency' do
  #     it 'returns nil' do
  #       seat_incumbency_node = @seat_incumbency_nodes[1]
  #
  #       expect(seat_incumbency_node.constituency).to be(nil)
  #     end
  #   end
  # end
  #
  describe '#member' do
    context 'Grom::Node has all the required objects' do
      it 'returns the member for a Grom::Node object of type Incumbency' do
        incumbency_node = @incumbency_nodes.first

        expect(incumbency_node.member.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    context 'Grom::Node has no member' do
      it 'returns nil' do
        incumbency_node = @incumbency_nodes[1]

        expect(incumbency_node.member).to be_nil
      end
    end
  end

  describe '#current?' do
    it 'Grom::Node returns the correct value for a current or non current incumbency' do
      incumbency_results = @incumbency_nodes.map(&:current?)

      expect(incumbency_results).to eq([false, true, true])
    end
  end
  #
  # describe '#contact_points' do
  #   context 'seat incumbency has contact points' do
  #     it 'returns an array of contact points' do
  #       seat_incumbency_node = response.filter('http://id.ukpds.org/schema/SeatIncumbency')[0]
  #
  #       expect(seat_incumbency_node).to respond_to(:contact_points)
  #       expect(seat_incumbency_node.contact_points.size).to eq 1
  #       expect(seat_incumbency_node.contact_points.first.type).to eq 'http://id.ukpds.org/schema/ContactPoint'
  #     end
  #   end
  #
  #   context 'constituency has no contact points' do
  #     it 'returns an empty array' do
  #       seat_incumbency_node = response.filter('http://id.ukpds.org/schema/SeatIncumbency')[1]
  #
  #       expect(seat_incumbency_node).to respond_to(:contact_points)
  #       expect(seat_incumbency_node.contact_points).to eq []
  #     end
  #   end
  # end
end
