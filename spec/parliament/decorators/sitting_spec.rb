require_relative '../../spec_helper'

describe Parliament::Decorators::Sitting do
  let(:data) { StringIO.new(File.read('spec/fixtures/people_members_current.nt')) }
  let(:objects) { Grom::Reader.new(data).objects }

  describe '#houses' do
    before(:each) do
      @sitting_nodes = objects.select { |object| object.type == 'http://id.ukpds.org/schema/Sitting' }
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node objects of type Sitting' do
        sitting_node = @sitting_nodes.first
        sitting_node.extend(Parliament::Decorators::Sitting)

        expect(sitting_node.houses.size).to eq(1)
        expect(sitting_node.houses.first.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context 'Grom::Node has no sittings' do
      it 'returns an empty array' do
        sitting_node = @sitting_nodes[1]
        sitting_node.extend(Parliament::Decorators::Sitting)

        expect(sitting_node.houses).to eq([])
      end
    end
  end
end
