module Parliament
  # API request object, allowing the user to build a request to a graph-based API, download n-triple data and create
  # ruby objects from that data.
  #
  # @since 0.1.0
  #
  # @attr_reader [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
  # @attr_reader [Hash] headers the headers being sent in the request.
  module Request
    Dir[File.join(File.dirname(__FILE__), '../parliament/request', '*.rb')].each { |request| require request }
  end
end
