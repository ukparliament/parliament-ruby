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

end