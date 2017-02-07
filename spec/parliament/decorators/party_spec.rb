require_relative '../../spec_helper'

describe Parliament::Decorators::Party, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get
  end

  before(:each) do
    @party_nodes = response.filter('http://id.ukpds.org/schema/Party').first
  end

  describe '#name' do
    context 'Grom::Node has all the required objects' do
      it 'confirms that the type for this Grom::Node object is Party' do
        party_node = @party_nodes.first

        expect(party_node.type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'returns the name of the party for the Grom::Node object' do
        party_node = @party_nodes.first

        expect(party_node.name).to eq('Labour')
      end
    end

    context 'Grom::Node does not have have a name' do
      it 'confirms that the name for this Grom::Node node does not exist' do
        objects_without_name_node = @party_nodes[1]

        expect(objects_without_name_node.name).to eq('')
      end
    end
  end
end
