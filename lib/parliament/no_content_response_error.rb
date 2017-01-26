module Parliament
  # An error raised when a 204 status code is returned by Net::HTTP inside of Parliament::Request.
  #
  # @since 0.6.0
  class NoContentResponseError < Parliament::NetworkError
    # @param [String] url the url that caused the Parliament::ClientError
    # @param [Net::HTTPResponse] response the Net:HTTPResponse that caused the Parliament::NoContentResponseError
    #
    # @example Creating a Parliament::NoContentResponseError
    #   url = 'http://localhost:3030/foo/bar'
    #
    #   response = Net::HTTP.get_response(URI(url))
    #
    #   raise Parliament::NoContentResponseError.new(url, response) if response.code == '204'
    def initialize(url, response)
      super
    end
  end
end
