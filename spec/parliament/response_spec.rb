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

    it 'should respond to empty?' do
      expect(subject).to respond_to(:empty?)
    end
  end

  describe '#filter' do
    before(:each) do
      @response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                      builder: Parliament::Builder::NTripleResponseBuilder).people.members.current.get
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
      expect(subject.filter('http://id.ukpds.org/schema/Person').size).to eq(0)
    end

    it 'returns a response filtered by a single type' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person')
      expect(filtered_response).to be_a(Parliament::Response)
    end

    it 'confirms that each Grom::Node is of type Person' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person')
      filtered_response.each do |node|
        expect(node.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'filters blank nodes' do
      filtered_response = @response.filter(Grom::Node::BLANK)
      expect(filtered_response).to be_a(Parliament::Response)
      expect(filtered_response.size).to eq(25)
    end

    it 'filters a mixture of typed nodes and blank nodes' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person', Grom::Node::BLANK)
      expect(filtered_response[0].size).to eq(3)
      expect(filtered_response[1].size).to eq(25)

      filtered_response[0].each do |node|
        expect(node.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'filters typed nodes from a mixture of typed nodes and blank nodes' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person')
      expect(filtered_response.size).to eq(3)

      filtered_response.each do |node|
        expect(node.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end
  end

  describe '#sort_by' do
    before(:each) do
      @response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                      builder: Parliament::Builder::NTripleResponseBuilder).people.members.current.get
    end

    it 'sorts the nodes in a Parliament::Response object by the given parameter' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/Person')
      sorted_response = filtered_response.sort_by(:family_name)

      expect(sorted_response[0].family_name).to eq('Person 1 - familyName')
      expect(sorted_response[1].family_name).to eq('Person 2 - familyName')
    end
  end

  describe '#reverse_sort_by' do
    before(:each) do
      @response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                      builder: Parliament::Builder::NTripleResponseBuilder).people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
    end

    it 'sorts the nodes in a Parliament::Response object by the given parameter' do
      filtered_response = @response.filter('http://id.ukpds.org/schema/SeatIncumbency')
      sorted_response = filtered_response.reverse_sort_by(:start_date)

      expect(sorted_response[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(sorted_response[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end
  end
end
