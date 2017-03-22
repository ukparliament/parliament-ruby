module Parliament
  # An error raised when a 5xx status code is returned by Net::HTTP inside of Parliament::Request.
  #
  # @see Parliament::ClientError
  #
  # @since 0.6.0
  class ServerError < Parliament::NetworkError
    # @param [String] url the url that caused the Parliament::ServerError
    # @param [Net::HTTPServerError] response the Net:HTTPServerError that caused the Parliament::ServerError
    #
    # @example Creating a Parliament::ServerError
    #   url = 'http://localhost:3030/foo/bar'
    #
    #   response = Net::HTTP.get_response(URI(url))
    #
    #   raise Parliament::ServerError.new(url, response) if response.is_a?(Net::HTTPServerError)
    def initialize(url, response)
      super
    end
  end
end
