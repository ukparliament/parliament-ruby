require_relative '../../spec_helper'

describe Parliament::Decorators::ConstituencyGroup, vcr: true do
  let(:id) { 'a2ce856d-ba0a-4508-9dd0-62feb54d3894' }
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').constituencies(id).get
  end

  describe '#name' do
    context 'constituency has a name' do
      it 'returns the name of the constituency' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:name)
        expect(constituency_node.name).to eq 'Sheffield, Brightside and Hillsborough'
      end
    end

    context 'constituency has no name' do
      it 'returns an empty string' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:name)
        expect(constituency_node.name).to eq ''
      end
    end
  end

  describe '#start_date' do
    context 'constituency has a start date' do
      it 'returns the start date of the constituency' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:start_date)
        expect(constituency_node.start_date).to eq '2010-05-06'
      end
    end

    context 'constituency has no start date' do
      it 'returns an empty string' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:start_date)
        expect(constituency_node.start_date).to eq ''
      end
    end
  end

  describe '#end_date' do
    context 'constituency has an end date' do
      it 'returns the end date of the constituency' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:end_date)
        expect(constituency_node.end_date).to eq '2011-05-06'
      end
    end

    context 'constituency has no end date' do
      it 'returns an empty string' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:end_date)
        expect(constituency_node.end_date).to eq ''
      end
    end
  end

  describe '#seats' do
    context 'constituency has house seats' do
      it 'returns an array of house seats' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:seats)
        expect(constituency_node.seats.size).to eq 1
        expect(constituency_node.seats.first.type).to eq 'http://id.ukpds.org/schema/HouseSeat'
      end
    end

    context 'constituency has no house seats' do
      it 'returns an empty array' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:seats)
        expect(constituency_node.seats).to eq []
      end
    end
  end

  describe '#seat_incumbencies' do
    context 'constituency has seat incumbencies' do
      it 'returns an array of seat incumbencies' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:seat_incumbencies)
        expect(constituency_node.seat_incumbencies.size).to eq 3
        expect(constituency_node.seat_incumbencies.first.type).to eq 'http://id.ukpds.org/schema/SeatIncumbency'
      end
    end

    context 'constituency has no seat incumbencies' do
      it 'returns an empty array' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:seat_incumbencies)
        expect(constituency_node.seat_incumbencies).to eq []
      end
    end
  end

  describe '#members' do
    context 'constituency has members' do
      it 'returns an array of members' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:members)
        expect(constituency_node.members.size).to eq 3
        expect(constituency_node.members.first.type).to eq 'http://id.ukpds.org/schema/Person'
      end
    end

    context 'constituency has no seat incumbencies' do
      it 'returns an empty array' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:members)
        expect(constituency_node.members).to eq []
      end
    end
  end

  describe '#area' do
    context 'constituency has an area' do
      it 'returns the area' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:area)
        expect(constituency_node.area.type).to eq 'http://id.ukpds.org/schema/ConstituencyArea'
      end
    end

    context 'constituency has no seat incumbencies' do
      it 'returns nil' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:area)
        expect(constituency_node.area).to be_nil
      end
    end
  end

  describe '#contact_points' do
    context 'constituency has contact points' do
      it 'returns an array of contact points' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[0]

        expect(constituency_node).to respond_to(:contact_points)
        expect(constituency_node.contact_points.size).to eq 1
        expect(constituency_node.contact_points.first.type).to eq 'http://id.ukpds.org/schema/ContactPoint'
      end
    end

    context 'constituency has no contact points' do
      it 'returns an empty array' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup')[1]

        expect(constituency_node).to respond_to(:contact_points)
        expect(constituency_node.contact_points).to eq []
      end
    end
  end
end
