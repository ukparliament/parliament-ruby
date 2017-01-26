require_relative '../spec_helper'

describe Parliament::ServerError do
  let(:response) { double(:response, code: '500', message: '500 error message') }

  subject { Parliament::ClientError.new('http://localhost:3030/foo/bar', response) }

  it 'has the expected message' do
    expect(subject.message).to eq '500 HTTP status code received from: http://localhost:3030/foo/bar - 500 error message'
  end
end