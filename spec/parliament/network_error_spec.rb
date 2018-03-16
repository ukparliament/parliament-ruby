require_relative '../spec_helper'

describe Parliament::NetworkError do
  let(:response) { double(:response, code: '12345', status_message: 'A message') }

  subject { Parliament::NetworkError.new('http://localhost:3030/foo/bar', response) }

  it 'has the expected message' do
    expect(subject.message).to eq '12345 HTTP status code received from: http://localhost:3030/foo/bar - A message'
  end
end
