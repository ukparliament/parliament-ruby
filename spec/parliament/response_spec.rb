require_relative '../spec_helper'

describe Parliament::Response, vcr: true do

  let(:nodes) { [] }
  subject { Parliament::Response.new(nodes) }

  describe '#initialize' do
    it 'sets an instance variable for the nodes' do
      expect(subject.instance_variable_get(:@nodes)).to eq(nodes)
    end
  end

  describe '#filter' do
    before(:each) do
      @response = Parliament::Request.new(base_url: 'http://localhost:3030').people.members.current.get
    end

    it 'returns an array of arrays of objects filtered by type' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person', 'http://id.ukdps.org/schema/Party')

      # TODO: add more expects to check types of things
      expect(filtered_response.first.size).to eq(3)
      expect(filtered_response.size).to eq(2)
      expect(filtered_response[1].size).to eq(3)
    end
  end
end