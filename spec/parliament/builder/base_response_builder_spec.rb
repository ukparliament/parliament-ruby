require_relative '../../spec_helper'

describe Parliament::Builder::BaseResponseBuilder, vcr: true do
  subject { Parliament::Builder::BaseResponseBuilder.new('hello world') }
  context 'build' do
    it 'returns a response' do
      expect(subject.build).to eq('hello world')
    end
  end
end