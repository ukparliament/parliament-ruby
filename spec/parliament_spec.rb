require 'spec_helper'

describe Parliament do
  it 'has a version number' do
    expect(Parliament::VERSION).not_to be nil
  end

  it 'is a module' do
    expect(Parliament.class).to be_a(Module)
  end
end
