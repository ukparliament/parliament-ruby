require_relative '../spec_helper'

describe Parliament::NoContentError, vcr: true do
  subject { Parliament::NoContentError.new }

  it 'has a message attribute' do
    expect(subject.message).to eq 'No content'
  end
end