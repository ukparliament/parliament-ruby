require_relative '../../spec_helper'

describe Parliament::Decorators::Constituency, vcr: true do
  let(:response) { Parliament::Request.new(base_url: 'http://localhost:3030').constituencies('a2ce856d-ba0a-4508-9dd0-62feb54d3894').get }

  describe '#name' do
    context 'constituency has a name' do
      it 'returns the name of the constituency' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first[0]
        constituency_node.extend(Parliament::Decorators::Constituency)

        expect(constituency_node).to respond_to(:name)
        expect(constituency_node.name).to eq 'Sheffield, Brightside and Hillsborough'
      end
    end

    context 'constituency has no name' do
      it 'returns an empty string' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first[1]
        constituency_node.extend(Parliament::Decorators::Constituency)

        expect(constituency_node).to respond_to(:name)
        expect(constituency_node.name).to eq ''
      end
    end
  end

  describe '#start_date' do
    context 'constituency has a start date' do
      it 'returns the name of the constituency' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first[0]
        constituency_node.extend(Parliament::Decorators::Constituency)

        expect(constituency_node).to respond_to(:start_date)
        expect(constituency_node.start_date).to eq '2010-05-06'
      end
    end

    context 'constituency has no start date' do
      it 'returns an empty string' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first[1]
        constituency_node.extend(Parliament::Decorators::Constituency)

        expect(constituency_node).to respond_to(:start_date)
        expect(constituency_node.start_date).to eq ''
      end
    end
  end

  describe '#end_date' do
    context 'constituency has a start date' do
      it 'returns the name of the constituency' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first[0]
        constituency_node.extend(Parliament::Decorators::Constituency)

        expect(constituency_node).to respond_to(:end_date)
        expect(constituency_node.end_date).to eq '2011-05-06'
      end
    end

    context 'constituency has no start date' do
      it 'returns an empty string' do
        constituency_node = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first[1]
        constituency_node.extend(Parliament::Decorators::Constituency)

        expect(constituency_node).to respond_to(:end_date)
        expect(constituency_node.start_date).to eq ''
      end
    end
  end
end
