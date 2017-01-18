require_relative '../spec_helper'

describe Parliament::Request, vcr: true do
  context 'with endpoint set via an initializer' do
    before :each do
      Parliament::Request.base_url = 'http://test.com'
    end

    it 'allows you to get the API endpoint within an instance' do
      expect(Parliament::Request.new.base_url).to eq('http://test.com')
    end

    it 'allows you to get the API endpoint on the class' do
      expect(Parliament::Request.base_url).to eq('http://test.com')
    end

    it 'allows you to override the API endpoint via the initializer' do
      expect(Parliament::Request.new(base_url: 'http://example.com').base_url).to eq('http://example.com')
    end
  end

  context 'with endpoint set by initializer' do
    it 'allows you to pass an endpoint within an initializer call' do
      expect(Parliament::Request.new(base_url: 'http://test.com').base_url).to eq('http://test.com')
    end
  end

  it 'does not accept setting base_url on an instance' do
    expect { Parliament::Request.new.base_url = 'http://test.com' }.to raise_error(NoMethodError)
  end

  describe '#method_missing' do
    subject { Parliament::Request.new(base_url: 'http://test.com') }

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
    subject { Parliament::Request.new(base_url: 'http://test.com') }
    it 'returns false for :base_url=' do
      expect(subject.send(:respond_to_missing?, :base_url=)).to eq(false)
    end

    it 'returns true for anything else' do
      expect(subject.send(:respond_to_missing?, :foo)).to eq(true)
    end
  end

  describe '#get' do
    subject { Parliament::Request.new(base_url: 'http://localhost:3030') }
    it 'returns a Net::HTTP Object' do
      expect(subject.parties.current.get).to be_a(String)
    end
  end
end
