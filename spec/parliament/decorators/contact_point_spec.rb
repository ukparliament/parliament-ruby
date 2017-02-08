require_relative '../../spec_helper'

describe Parliament::Decorators::ContactPoint, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('08a3dfac-652a-44d6-8a43-00bb13c60e47').get
  end

  before(:each) do
    @contact_point_nodes = response.filter('http://id.ukpds.org/schema/ContactPoint').first
  end

  describe '#postal_addresses' do
    context 'Grom::Node has all the required objects' do
      it 'returns the postal addresses for a Grom::Node object of type ContactPoint' do
        contact_point_node = @contact_point_nodes.first

        expect(contact_point_node.postal_addresses.size).to eq(1)
        expect(contact_point_node.postal_addresses.first.type).to eq('http://id.ukpds.org/schema/PostalAddress')
      end
    end

    context 'Grom::Node has no postal addresses' do
      it 'returns an empty array' do
        contact_point_node = @contact_point_nodes[1]

        expect(contact_point_node.postal_addresses).to eq([])
      end
    end
  end
end
