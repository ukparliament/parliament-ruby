require_relative '../../spec_helper'

describe Parliament::Builder::OpenSearchResponseBuilder, vcr: true do
  let(:request) do
    Parliament::Request::OpenSearchRequest.new(base_url: 'http://parliament-search-api.azurewebsites.net/description',
                                               headers: { 'Accept' => 'application/atom+xml' },
                                               builder: Parliament::Builder::OpenSearchResponseBuilder)
  end

  context 'build' do
    before(:each) do
      @search_response = request.get({ query: 'banana', start_page: '10' })
    end

    it 'returns a Feedjira::Feed object' do
      expect(@search_response).to be_a(Feedjira::Parser::Atom)
    end
  end
end