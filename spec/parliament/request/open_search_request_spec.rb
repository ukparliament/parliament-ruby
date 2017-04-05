require_relative '../../spec_helper'

describe Parliament::Request::OpenSearchRequest, vcr: true do
  context 'initializing' do
    it 'sets @base_url correctly when passed in' do
      request = Parliament::Request::OpenSearchRequest.new(base_url: 'http://parliament-search-api.azurewebsites.net/description')

      expect(request.base_url).to eq('http://parliament-search-api.azurewebsites.net/search?q={searchTerms}&start={startPage?}')
    end

    it 'sets @base_url correctly when set on the class' do
      Parliament::Request::OpenSearchRequest.base_url = 'http://parliament-search-api.azurewebsites.net/description'
      request = Parliament::Request::OpenSearchRequest.new

      expect(request.base_url).to eq('http://parliament-search-api.azurewebsites.net/search?q={searchTerms}&start={startPage?}')
    end
  end

  context '#get' do
    before(:each) do
      request = Parliament::Request::OpenSearchRequest.new(base_url: 'http://parliament-search-api.azurewebsites.net/description',
                                                            headers: { 'Accept' => 'application/atom+xml' },
                                                            builder: Parliament::Builder::OpenSearchResponseBuilder)
      @result = request.get({ query: 'banana', start_page: '10' })
    end

    it 'returns a Feedjira Feed' do
      expect(@result).to be_a(Feedjira::Parser::Atom)
    end

    it 'returns the correct data within the Feedjira Feed' do
      expect(@result.entries.first.title).to eq('House of Commons Standing Committee (pt 3)')
      expect(@result.entries.first.summary).to include('Because <b>bananas</b> are the top-selling fruit')
      expect(@result.entries.first.url).to eq('http://www.publications.parliament.uk/pa/cm199798/cmstand/euroa/st980325/80325s03.htm')
      expect(@result.totalResults).to eq('18800')
    end
  end
end