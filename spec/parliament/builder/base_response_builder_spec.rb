require_relative '../../spec_helper'

describe Parliament::Builder::BaseResponseBuilder, vcr: true do
  subject { Parliament::Builder::BaseResponseBuilder.new(response: 'hello world') }
  context 'build' do
    it 'returns a Parliament::Response::BaseResponse' do
      expect(subject.build).to be_a(Parliament::Response::BaseResponse)
    end
  end
end