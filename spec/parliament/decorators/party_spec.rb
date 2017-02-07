require_relative '../../spec_helper'

describe Parliament::Decorators::Party do
  let(:data) { StringIO.new(File.read('spec/fixtures/parties_current.nt')) }
  let(:empty_name) { StringIO.new(File.read('spec/fixtures/no_current_parties.nt')) }
  let(:objects) { Grom::Reader.new(data).objects }
  let(:objects_without_name) { Grom::Reader.new(empty_name).objects }
  let(:party_node) { objects.first }
  let(:objects_without_name_node) { objects_without_name.first }

  describe '#name' do
    context 'Grom::Node has all the required objects' do
      it 'confirms that the type for this Grom::Node object is Party' do
        expect(party_node.type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'returns the name of the party for the Grom::Node object' do
        party_node.extend(Parliament::Decorators::Party)
        expect(party_node.name).to eq('Labour')
      end
    end

    context 'Grom::Node does not have have a name' do
      it 'confirms that the name for this Grom::Node node does not exist' do
        objects_without_name_node.extend(Parliament::Decorators::Party)
        expect(objects_without_name_node.name).to eq('')
      end
    end
  end
end
