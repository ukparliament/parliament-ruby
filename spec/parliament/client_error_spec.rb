require_relative '../spec_helper'

describe Parliament::ClientError do
  let(:response) { double(:response, code: '400', status_message: '400 error message') }

  subject { Parliament::ClientError.new('http://localhost:3030/foo/bar', response) }

  it 'has the expected message' do
    expect(subject.message).to eq '400 HTTP status code received from: http://localhost:3030/foo/bar - 400 error message'
  end
end
