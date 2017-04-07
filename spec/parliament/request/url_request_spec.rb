require_relative '../../spec_helper'

describe Parliament::Request::UrlRequest, vcr: true do
  describe '#method_missing' do
    subject { Parliament::Request::UrlRequest.new(base_url: 'http://test.com') }

    it 'stores method names in @endpoint_parts' do
      request = subject.people

      expect(request.instance_variable_get(:@endpoint_parts)).to eq(['people'])
    end

    it 'stores method parameters into @endpoint_parts' do
      request = subject.people('123')

      expect(request.instance_variable_get(:@endpoint_parts)).to eq(%w(people 123))
    end

    it 'stores multiple method parameters into @endpoint_parts' do
      request = subject.people('123', '456')

      expect(request.instance_variable_get(:@endpoint_parts)).to eq(%w(people 123 456))
    end
  end

  describe '#respond_to_missing?' do
    subject { Parliament::Request::UrlRequest.new(base_url: 'http://test.com') }

    it 'returns true for anything' do
      expect(subject.send(:respond_to_missing?, :foo)).to eq(true)
      expect(subject.send(:respond_to_missing?, :bar)).to eq(true)
    end
  end
end