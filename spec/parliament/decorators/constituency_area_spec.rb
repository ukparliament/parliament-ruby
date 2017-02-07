require_relative '../../spec_helper'

describe Parliament::Decorators::ConstituencyArea, vcr: true do
  let(:response) { Parliament::Request.new(base_url: 'http://localhost:3030').constituencies('a2ce856d-ba0a-4508-9dd0-62feb54d3894').get }

  describe '#latitude' do
    context 'constituency has a latitude' do
      it 'returns the latitude of the constituency area' do
        constituency_area_node = response.filter('http://id.ukpds.org/schema/ConstituencyArea').first[0]

        expect(constituency_area_node).to respond_to(:latitude)
        expect(constituency_area_node.latitude).to eq '53.4156316801'
      end
    end

    context 'constituency has no latitude' do
      it 'returns an empty string' do
        constituency_area_node = response.filter('http://id.ukpds.org/schema/ConstituencyArea').first[1]

        expect(constituency_area_node).to respond_to(:latitude)
        expect(constituency_area_node.latitude).to eq ''
      end
    end
  end

  describe '#longitude' do
    context 'constituency has a longitude' do
      it 'returns the longitude of the constituency area' do
        constituency_area_node = response.filter('http://id.ukpds.org/schema/ConstituencyArea').first[0]

        expect(constituency_area_node).to respond_to(:longitude)
        expect(constituency_area_node.longitude).to eq '-1.46711981738'
      end
    end

    context 'constituency has no longitude' do
      it 'returns an empty string' do
        constituency_area_node = response.filter('http://id.ukpds.org/schema/ConstituencyArea').first[1]

        expect(constituency_area_node).to respond_to(:longitude)
        expect(constituency_area_node.longitude).to eq ''
      end
    end
  end

  describe '#polygon' do
    context 'constituency has a polygon' do
      it 'returns the polygon of the constituency area' do
        constituency_area_node = response.filter('http://id.ukpds.org/schema/ConstituencyArea').first[0]

        expect(constituency_area_node).to respond_to(:polygon)
        expected_polygon = 'Polygon((-1.50958909420 53.39937821832,-1.50978426399 53.39941048368))'
        expect(constituency_area_node.polygon).to eq expected_polygon
      end
    end

    context 'constituency has no polygon' do
      it 'returns an empty string' do
        constituency_area_node = response.filter('http://id.ukpds.org/schema/ConstituencyArea').first[1]

        expect(constituency_area_node).to respond_to(:polygon)
        expect(constituency_area_node.polygon).to eq ''
      end
    end
  end
end
