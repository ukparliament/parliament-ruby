require_relative '../spec_helper'
require 'pry'

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

        expect(linked_objects.first.sittings.first.constituencies.first.constituencyName).to eq('Constituency 1 - name')
      end
    end

    context 'it returns any other status code than a 200' do

      #stub_request(:get, 'http://localhost:3030/dogs/cats.nt').to_raise(StandardError)

      it 'and raises client error when status is within the 400 range' do
        stub_request(:get, 'http://localhost:3030/dogs/cats.nt').to_return(status: 400)
        expect{Parliament::Request.new(base_url: 'http://localhost:3030').dogs.cats.get}.to raise_error(StandardError, 'This is a HTTPClientError')

      end

      it 'and raises server error when status is within the 500 range' do
        stub_request(:get, 'http://localhost:3030/parties/current.nt').to_return(status: 500)
        expect{Parliament::Request.new(base_url: 'http://localhost:3030').parties.current.get}.to raise_error(StandardError, 'This is a HTTPServerError')

      end
    end
  end
end
