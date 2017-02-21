module Parliament
  class NoContentError < StandardError
    attr_reader :message

    def initialize
      @message = 'No content'
    end
  end
end
