require_relative '../../spec_helper'

describe Parliament::Request::UrlRequest, vcr: true do
  describe '#method_missing' do
    subject { Parliament::Request::UrlRequest.new(base_url: 'http://test.com', decorators: Parliament::Grom::Decorator) }

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
    subject { Parliament::Request::UrlRequest.new(base_url: 'http://test.com', decorators: Parliament::Grom::Decorator) }

    it 'returns true for anything' do
      expect(subject.send(:respond_to_missing?, :foo)).to eq(true)
      expect(subject.send(:respond_to_missing?, :bar)).to eq(true)
    end
  end

  describe '#query_url' do
    it 'makes a request to the correctly built endpoint' do
      request = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030', decorators: Parliament::Grom::Decorator)

      request.people.members.current.get

      expect(WebMock).to have_requested(:get, 'http://localhost:3030/people/members/current').
          with(:headers => {'Accept'=>['*/*', 'application/n-triples'], 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).once

    end
  end
end