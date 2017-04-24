require_relative '../../spec_helper'

describe Parliament::Response::BaseResponse do
  let(:response) { 'hello world' }
  let(:nil_response) { nil }

  describe 'setting the response variable' do
    it 'sets the response variable when a value is passed in' do
      base_response = Parliament::Response::BaseResponse.new('hello world')

      expect(base_response.response).to eq('hello world')
    end

    it 'sets the response variable to nil when a nil value is passed in' do
      base_response = Parliament::Response::BaseResponse.new(nil)

      expect(base_response.response).to be(nil)
    end
  end
end
