require_relative '../spec_helper'

describe Parliament::Response, vcr: true do
  let(:nodes) { [] }
  subject { Parliament::Response.new(nodes) }

  describe '#initialize' do
    it 'sets an instance variable for the nodes' do
      expect(subject.instance_variable_get(:@nodes)).to eq(nodes)
    end

    it 'should respond to size' do
      expect(subject).to respond_to(:size)
    end

    it 'should respond to each' do
      expect(subject).to respond_to(:each)
    end

    it 'should respond to select' do
      expect(subject).to respond_to(:select)
    end

    it 'should respond to map' do
      expect(subject).to respond_to(:map)
    end

    it 'should respond to select!' do
      expect(subject).to respond_to(:select!)
    end

    it 'should respond to map!' do
      expect(subject).to respond_to(:map!)
    end

    it 'should respond to count' do
      expect(subject).to respond_to(:count)
    end

    it 'should respond to length' do
      expect(subject).to respond_to(:length)
    end

    it 'should respond to []' do
      expect(subject).to respond_to(:[])
    end
  end

  describe '#filter' do
    before(:each) do
      @response = Parliament::Request.new(base_url: 'http://localhost:3030').people.members.current.get
    end

    it 'returns an empty array when no types are passed in' do
      filtered_response = @response.filter

      expect(filtered_response.size).to eq(0)
    end

    it 'returns an array of arrays of objects filtered by type Person' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/Party')

      expect(filtered_response.first.size).to eq(3)

      expect(filtered_response.size).to eq(2)

      filtered_response.first.each do |node|
        expect(node.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'returns an array of arrays of objects filtered by type Party' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/Party')
      expect(filtered_response[1].size).to eq(1)

      filtered_response[1].each do |node|
        expect(node.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    it 'returns an empty array of response objects when the type passed in does not exist' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person', 'banana')

      expect(filtered_response.first.size).to eq(3)
      expect(filtered_response[1].size).to eq(0)
    end

    it 'returns an empty array when the response is empty' do
      expect(subject.filter('http://id.ukpds.org/schema/Person').first.size).to eq(0)
    end
  end
end
