require_relative '../spec_helper'

describe Parliament::Person do

  let(:data) { StringIO.new(File.read('spec/fixtures/people_members_current.nt')) }
  let(:objects) { Grom::Reader.new(data).objects }

  describe '#houses' do
    # before(:each) do
    #   @person_nodes = objects.select{ |object| object.type == 'http://id.ukpds.org/schema/Person' }
    # end
    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node objects of type Person' do
        person_node = objects.select{ |object| object.type == 'http://id.ukpds.org/schema/Person' }.first
        # person_node = person_nodes.first
        person_node.extend(Parliament::Person)

        expect(person_node.houses.size).to eq(1)
      end
    end

    xcontext 'Grom::Node is has no sittings' do
      it 'returns nil' do
        person_nodes = objects.select{ |object| object.type == 'http://id.ukpds.org/schema/Person' }

        person_node = person_nodes[2]
        person_node.extend(Parliament::Person)

        expect(person_node.houses).to be_nil
      end
    end
  end
end