require_relative '../../spec_helper'

describe Parliament::Decorators::Person do
  let(:data) { StringIO.new(File.read('spec/fixtures/people_members_current.nt')) }
  let(:objects) { Grom::Reader.new(data).objects }

  describe '#houses' do
    before(:each) do
      @person_nodes = objects.select { |object| object.type == 'http://id.ukpds.org/schema/Person' }
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node objects of type Person' do
        person_node = @person_nodes.first
        person_node.extend(Parliament::Decorators::Person)

        expect(person_node.houses.size).to eq(1)
        expect(person_node.houses.first.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    context 'Grom::Node has no sittings' do
      it 'returns an empty array' do
        person_node = @person_nodes[2]
        person_node.extend(Parliament::Decorators::Person)

        expect(person_node.houses).to eq([])
      end
    end
  end

  describe '#sittings' do
    before(:each) do
      @person_nodes = objects.select { |object| object.type == 'http://id.ukpds.org/schema/Person' }
    end

    context 'Grom::Node has all the required objects' do
      it 'returns the houses for a Grom::Node objects of type Person' do
        person_node = @person_nodes.first
        person_node.extend(Parliament::Decorators::Person)

        expect(person_node.sittings.size).to eq(1)
        expect(person_node.sittings.first.type).to eq('http://id.ukpds.org/schema/Sitting')
      end
    end

    context 'Grom::Node has no sittings' do
      it 'returns an empty array' do
        person_node = @person_nodes[2]
        person_node.extend(Parliament::Decorators::Person)

        expect(person_node.sittings).to eq([])
      end
    end
  end
end
