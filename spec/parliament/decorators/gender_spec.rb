require_relative '../../spec_helper'

describe Parliament::Decorators::Gender, vcr: true do
  let(:response) do
    Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get
  end

  before(:each) do
    @gender_nodes = response.filter('http://id.ukpds.org/schema/Gender')
  end

  describe '#name' do
    context 'Grom::Node has all the required objects' do
      it 'returns the name for a Grom::Node object of type Gender' do
        gender_node = @gender_nodes.first

        expect(gender_node.name).to eq('F')
      end
    end

    context 'Grom::Node has no name' do
      it 'returns an empty string' do
        gender_node = @gender_nodes[1]

        expect(gender_node.name).to eq('')
      end
    end
  end
end
