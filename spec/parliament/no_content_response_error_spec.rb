require_relative '../spec_helper'

describe Parliament::NoContentResponseError, vcr: true do
  let(:response) { double(:response, code: '200', message: 'OK') }

  subject { Parliament::NoContentResponseError.new('http://localhost:3030/foo/bar', response) }

  it 'has the expected message' do
    expect(subject.message).to eq '200 HTTP status code received from: http://localhost:3030/foo/bar - OK'
  end
end