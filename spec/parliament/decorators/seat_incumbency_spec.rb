require_relative '../../spec_helper'

describe Parliament::Decorators::SeatIncumbency do
  let(:data) { StringIO.new(File.read('spec/fixtures/person.nt')) }
  let(:objects) { Grom::Reader.new(data).objects }


end
