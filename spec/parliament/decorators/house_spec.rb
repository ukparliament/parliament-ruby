require_relative '../../spec_helper'

describe Parliament::Decorators::House, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get
  end

  describe '#name' do
    before(:each) do
      @house_nodes = response.filter('http://id.ukpds.org/schema/House')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the name for a Grom::Node object of type House' do
        house_node = @house_nodes.first

        expect(house_node.name).to eq('House of Commons')
      end
    end

    context 'Grom::Node has no name' do
      it 'returns an empty string' do
        house_node = @house_nodes.first

        expect(house_node.name).to eq('')
      end
    end
  end

  describe '#seats' do
    before(:each) do
      id = 'ff75cd0c-1a8b-49ab-8292-f00d153588e5'
      response = Parliament::Request.new(base_url: 'http://localhost:3030').people(id).houses.get
      @house_nodes = response.filter('http://id.ukpds.org/schema/House')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the seats for a Grom::Node object of type House' do
        house_node = @house_nodes.first

        expect(house_node.seats.size).to eq(3)
        expect(house_node.seats.first.type).to eq('http://id.ukpds.org/schema/HouseSeat')
      end
    end

    context 'Grom::Node has no seats' do
      it 'returns an empty string' do
        house_node = @house_nodes.first

        expect(house_node.seats).to eq([])
      end
    end
  end

  describe '#seat_incumbencies' do
    before(:each) do
      id = 'ff75cd0c-1a8b-49ab-8292-f00d153588e5'
      response = Parliament::Request.new(base_url: 'http://localhost:3030').people(id).houses.get
      @house_nodes = response.filter('http://id.ukpds.org/schema/House')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the seat_incumbencies for a Grom::Node object of type House' do
        house_node = @house_nodes.first

        expect(house_node.seat_incumbencies.size).to eq(6)
        expect(house_node.seat_incumbencies.first.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end
    end

    context 'Grom::Node has no seat incumbencies' do
      it 'returns an empty string' do
        house_node = @house_nodes.first

        expect(house_node.seat_incumbencies).to eq([])
      end
    end
  end

  describe '#house_incumbencies' do
    before(:each) do
      id = '90558d1f-ea34-4c44-b3ad-ed9c98a557d1'
      response = Parliament::Request.new(base_url: 'http://localhost:3030').people(id).houses.get
      @house_nodes = response.filter('http://id.ukpds.org/schema/House')
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the house_incumbencies for a Grom::Node object of type House' do
        house_node = @house_nodes.first

        expect(house_node.house_incumbencies.size).to eq(1)
        expect(house_node.house_incumbencies.first.type).to eq('http://id.ukpds.org/schema/HouseIncumbency')
      end
    end

    context 'Grom::Node has no house incumbencies' do
      it 'returns an empty string' do
        house_node = @house_nodes.first

        expect(house_node.house_incumbencies).to eq([])
      end
    end
  end
end
