require_relative '../../spec_helper'

describe Parliament::Decorators::Constituency do
  let(:data) { StringIO.new(File.read('spec/fixtures/constituency.nt')) }
  let(:objects) { Grom::Reader.new(data).objects }

  describe '#name' do
    before(:each) do
      @constituency_node = objects.select { |object| object.type == 'http://id.ukpds.org/schema/ConstituencyGroup' }.first
      @constituency_node.extend(Parliament::Decorators::Constituency)
    end

    it 'responds to #name' do
      expect(@constituency_node).to respond_to(:name)
    end

    it 'returns the name of the constituency' do
      expect(@constituency_node.name).to eq 'Sheffield, Brightside and Hillsborough'
    end
  end

  # describe '#houses' do
  #   before(:each) do
  #     @constituency_node = objects.select { |object| object.type == 'http://id.ukpds.org/schema/ConstituencyGroup' }
  #   end
  #
  #   context 'Grom::Node has all the required objects' do
  #     it 'returns the houses for a Grom::Node objects of type Person' do
  #       person_node = @person_nodes.first
  #       person_node.extend(Parliament::Decorators::Person)
  #
  #       expect(person_node.houses.size).to eq(1)
  #       expect(person_node.houses.first.type).to eq('http://id.ukpds.org/schema/House')
  #     end
  #   end
  #
  #   context 'Grom::Node has no sittings' do
  #     it 'returns an empty array' do
  #       person_node = @person_nodes[2]
  #       person_node.extend(Parliament::Decorators::Person)
  #
  #       expect(person_node.houses).to eq([])
  #     end
  #   end
  # end

end