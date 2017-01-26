module Parliament
  module Person
    def houses
      # TODO: error handling
      self.sittings.first.houses
    end
  end
end