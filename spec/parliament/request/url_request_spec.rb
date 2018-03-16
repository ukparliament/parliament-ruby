require_relative '../../spec_helper'

describe Parliament::Request::UrlRequest, vcr: true do
  describe '#method_missing' do
    subject { Parliament::Request::UrlRequest.new(base_url: 'http://test.com', decorators: Parliament::Grom::Decorator) }

    it 'stores method names in @endpoint_parts' do
      request = subject.people

      expect(request.instance_variable_get(:@endpoint_parts)).to include('people')
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

      expect(request.query_url.to_s).to eq('http://localhost:3030/people/members/current')

      expect(WebMock).to have_requested(:get, 'http://localhost:3030/people/members/current').
        with(:headers => {'Accept'=>['*/*', 'application/n-triples'],  'User-Agent'=>'Ruby'}).once
    end

    context 'with query_params set' do
      it 'generates a url as expected' do
        request = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030', decorators: Parliament::Grom::Decorator)

        request.people.set_url_params({ person_id: '12345', foo: 'bar', test: true })

        expect(request.query_url.to_s).to eq('http://localhost:3030/people')

        request.get(params: { foo: 'foo', hello: 'world' })

        expect(WebMock).to have_requested(:get, 'http://localhost:3030/people?foo=foo&hello=world&person_id=12345&test=true').
          with(:headers => {'Accept'=>['*/*', 'application/n-triples'],  'User-Agent'=>'Ruby'}).once
      end
    end
  end

  describe '#set_url_params' do
    it 'builds a query string' do
      request = subject.people.set_url_params({ people_id: 1234, house_id: 5678 })
      expect(request.instance_variable_get(:@query_params)).to eq({ :people_id=>1234, :house_id=>5678 })
    end
  end
end
