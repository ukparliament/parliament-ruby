require_relative '../../spec_helper'

describe Parliament::Response, vcr: true do
  let(:response) { 'hello world' }
  subject { Parliament::Response::BaseResponse.new(response) }

  it 'has a response' do
    expect(subject.response).to eq('hello world')
  end
end
