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
  end

  describe '#sort_by' do
    context 'all nodes have the parameter being sorted on' do
      it 'returns a response sorted by personFamilyName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName)

        expect(sorted_response.first.personGivenName).to eq('Jane')
      end

      it 'returns a response sorted by seatIncumbencyStartDate' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people('2c196540-13f3-4c07-8714-b356912beceb').get
        filtered_response = response.filter('http://id.ukpds.org/schema/SeatIncumbency')
        sorted_response = filtered_response.sort_by(:start_date)

        expect(sorted_response.first.start_date).to eq(DateTime.new(1987, 6, 11))
        expect(sorted_response[1].start_date).to eq(DateTime.new(1992, 4, 9))
      end
    end

    context 'not all nodes have the parameter being sorted on' do
      it 'returns a response sorted by personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personGivenName)

        expect(sorted_response.first.personFamilyName).to eq('A')
        expect(sorted_response[1].personGivenName).to eq('Alice')
      end
    end

    context 'sorting by multiple parameters' do
      it 'returns a response sorted by personFamilyName, then personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName, :personGivenName)

        expect(sorted_response.first.personGivenName).to eq('Rebecca')
        expect(sorted_response[1].personGivenName).to eq('Sarah')
      end
    end

    context 'sorting strings of different cases' do
      it 'returns a response sorted by personFamilyName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName)

        expect(sorted_response.first.personGivenName).to eq('Jane')
        expect(sorted_response[1].personGivenName).to eq('Alice')
      end
    end

    context 'sorting strings with accents' do
      it 'returns a response sorted by personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personGivenName)

        expect(sorted_response.first.personGivenName).to eq('Sarah')
        expect(sorted_response[1].personGivenName).to eq('Sóley')
        expect(sorted_response[2].personGivenName).to eq('Solomon')
      end

      it 'returns a response sorted by personFamilyName, personGivenName' do
        response = Parliament::Request.new(base_url: 'http://localhost:3030').people.get
        sorted_response = response.sort_by(:personFamilyName, :personGivenName)

        expect(sorted_response.first.personGivenName).to eq('Solomon')
        expect(sorted_response[1].personGivenName).to eq('Sophie')
        expect(sorted_response[2].personGivenName).to eq('Sarah')
      end
    end
  end
end
