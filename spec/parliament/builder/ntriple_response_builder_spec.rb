require_relative '../../spec_helper'

describe Parliament::Builder::NTripleResponseBuilder, vcr: true do
  let(:response) { Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030').people.members.current.get }
  subject { Parliament::Builder::NTripleResponseBuilder.new(response) }

  context 'build' do
    before(:each) do
      @parliament_response = subject.build
    end

    it 'returns a Parliament::Response object' do
      expect(@parliament_response).to be_a(Parliament::Response)
    end

    it 'returns 19 objects' do
      expect(@parliament_response.size).to eq(19)
    end

    it 'returns an array of Grom::Node objects' do
      @parliament_response.each do |object|
        expect(object).to be_a(Grom::Node)
      end
    end
  end

  describe '#assign_decorator' do
    it 'returns an object which has been decorated if a decorator is defined' do

      person = subject.build.select { |node| node.type == 'http://id.ukpds.org/schema/Person' }.first

      expect(person).to respond_to(:houses)
    end

    it 'decorates nested objects' do
      person = subject.build.select { |node| node.type == 'http://id.ukpds.org/schema/Person' }.first

      expect(person.memberHasSeatIncumbency.first).to respond_to(:seat)
    end
  end
end