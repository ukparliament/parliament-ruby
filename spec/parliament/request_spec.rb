require_relative '../spec_helper'

describe Parliament::Request, vcr: true do
  context 'with endpoint set via an initializer' do
    before :each do
      Parliament::Request.base_url = 'http://test.com'
    end

    it 'allows you to get the API endpoint within an instance' do
      expect(Parliament::Request.new.base_url).to eq('http://test.com')
    end

    it 'allows you to get the API endpoint on the class' do
      expect(Parliament::Request.base_url).to eq('http://test.com')
    end

    it 'allows you to override the API endpoint via the initializer' do
      expect(Parliament::Request.new(base_url: 'http://example.com').base_url).to eq('http://example.com')
    end
  end

  context 'with endpoint set by initializer' do
    it 'allows you to pass an endpoint within an initializer call' do
      expect(Parliament::Request.new(base_url: 'http://test.com').base_url).to eq('http://test.com')
    end
  end

  it 'does not accept setting base_url on an instance' do
    expect { Parliament::Request.new.base_url = 'http://test.com' }.to raise_error(NoMethodError)
  end

  describe '#method_missing' do
    subject { Parliament::Request.new(base_url: 'http://test.com') }

    it 'stores method names in @endpoint_parts' do
      request = subject.people

      expect(request.instance_variable_get(:@endpoint_parts)).to eq(['people'])
    end

    it 'stores method parameters into @endpoint_parts' do
      request = subject.people('123')

      expect(request.instance_variable_get(:@endpoint_parts)).to eq(%w(people 123))
    end

    it 'stores multiple method parameters into @endpoint_parts' do
      request = subject.people('123', '456')

      expect(request.instance_variable_get(:@endpoint_parts)).to eq(%w(people 123 456))
    end
  end

  describe '#respond_to_missing?' do
    subject { Parliament::Request.new(base_url: 'http://test.com') }
    it 'returns false for :base_url=' do
      expect(subject.send(:respond_to_missing?, :base_url=)).to eq(false)
    end

    it 'returns true for anything else' do
      expect(subject.send(:respond_to_missing?, :foo)).to eq(true)
    end
  end

  describe '#get' do
    context 'it returns a status code of 200 and ..' do
      subject { Parliament::Request.new(base_url: 'http://localhost:3030').parties.current.get }

      it 'returns a Parliament::Response' do
        expect(subject).to be_a(Parliament::Response)
      end

      it 'returns 27 objects' do
        expect(subject.size).to eq(27)
      end

      it 'returns an array of Grom::Node objects' do
        subject.each do |object|
          expect(object).to be_a(Grom::Node)
        end
      end

      # NOTE: ensure all fixtures use anonymised data
      it 'returns linked objects where links are in the data' do
        linked_objects = Parliament::Request.new(base_url: 'http://localhost:3030').people.members.current.get
        result = linked_objects.first.personHasSitting.first.sittingHasConstituency.first.constituencyName

        expect(result).to eq('Constituency 1 - name')
      end
    end

    context 'it returns a status code of 204 and...' do
      it 'raises a Parliament::NoContentError' do
        past_person_id = '321f496b-5c8b-4455-ab49-a96e42b34739'
        expect do
          Parliament::Request.new(base_url: 'http://localhost:3030').people(past_person_id).parties.current.get
        end.to raise_error(Parliament::NoContentError, 'No content')
      end
    end

    context 'it returns a status code in either the 400 or 500 range' do
      it 'and raises client error when status is within the 400 range' do
        stub_request(:get, 'http://localhost:3030/dogs/cats.nt').to_return(status: 400)

        expect do
          Parliament::Request.new(base_url: 'http://localhost:3030').dogs.cats.get
        end.to raise_error(StandardError, 'This is a HTTPClientError')
      end

      it 'and raises server error when status is within the 500 range' do
        stub_request(:get, 'http://localhost:3030/parties/current.nt').to_return(status: 500)

        expect do
          Parliament::Request.new(base_url: 'http://localhost:3030').parties.current.get
        end.to raise_error(StandardError, 'This is a HTTPServerError')
      end
    end
  end

  describe '#assign_decorator' do
    # TODO: think of a way to test whether a node has not been decorated

    before(:each) do
      @response = Parliament::Request.new(base_url: 'http://localhost:3030').people.members.current.get
    end

    it 'returns an object which has been decorated if a decorator is defined' do
      person = @response.select { |node| node.type == 'http://id.ukpds.org/schema/Person' }.first

      expect(person).to respond_to(:houses)
    end

    it 'decorates nested objects' do
      person = @response.select { |node| node.type == 'http://id.ukpds.org/schema/Person' }.first

      expect(person.memberHasSeatIncumbency.first).to respond_to(:seat)
    end
  end
end
