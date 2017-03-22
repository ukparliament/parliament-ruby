module Parliament
  # An error raised when a 4xx status code is returned by Net::HTTP inside of Parliament::Request.
  #
  # @see Parliament::ServerError
  #
  # @since 0.6.0
  class ClientError < Parliament::NetworkError
    # @param [String] url the url that caused the Parliament::ClientError
    # @param [Net::HTTPClientError] response the Net:HTTPClientError that caused the Parliament::ClientError
    #
    # @example Creating a Parliament::ClientError
    #   url = 'http://localhost:3030/foo/bar'
    #
    #   response = Net::HTTP.get_response(URI(url))
    #
    #   raise Parliament::ClientError.new(url, response) if response.is_a?(Net::HTTPClientError)
    def initialize(url, response)
      super
    end
  end
end
