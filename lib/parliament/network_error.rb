module Parliament
  # A parent class that standardises the error message generated for network errors.
  #
  # @see Parliament::ClientError
  # @see Parliament::ServerError
  #
  # @since 0.6.0
  class NetworkError < StandardError
    def initialize(url, response)
      super("#{response.code} HTTP status code received from: #{url} - #{response.status_message}")
    end
  end
end
