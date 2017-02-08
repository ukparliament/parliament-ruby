require_relative '../../spec_helper'

describe Parliament::Decorators::PostalAddress, vcr: true do
  let(:id) { '8d895ffc-c2bf-43d2-b756-95ab3e987919' }
  let(:response) { Parliament::Request.new(base_url: 'http://localhost:3030').constituencies(id).contact_point.get }

  before(:each) do
    @postal_address_nodes = response.filter('http://id.ukpds.org/schema/PostalAddress').first
  end

  describe '#full_address' do
    context 'Grom::Node has all the required objects' do
      it 'returns the full address for a Grom::Node object of type PostalAddress' do
        postal_address_node = @postal_address_nodes.first

        expect(postal_address_node).to respond_to(:full_address)
        expected_full_address = 'House of Commons, London, SW1A 0AA'
        expect(postal_address_node.full_address).to eq(expected_full_address)
      end
    end

    context 'Grom::Node has no postal addresses' do
      it 'returns an empty array' do
        postal_address_node = @postal_address_nodes[1]

        expect(postal_address_node.full_address).to eq('')
      end
    end
  end
end
