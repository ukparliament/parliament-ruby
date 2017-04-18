module Parliament
  module Request
    # API request object, allowing the user to build a request to an API.
    #
    # @since 0.7.5
    #
    # @attr_reader [String] base_url the base url of our API. (expected: http://example.com - without the trailing slash).
    # @attr_reader [Hash] headers the headers being sent in the request.
    class UrlRequest < Parliament::Request::BaseRequest
      # Creates a new instance of Parliament::Request::UrlRequest.
      #
      # @see Parliament::Request::BaseRequest#initialize.
      #
      # @param [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
      # @param [Hash] headers the headers being sent in the request.
      # @param [Parliament::Builder] builder the builder to use in order to build a response.
      # @params [Module] decorators the decorator module to use in order to provide possible alias methods for any objects created by the builder.
      def initialize(base_url: nil, headers: nil, builder: nil, decorators: nil)
        @endpoint_parts = []
        base_url ||= ENV['PARLIAMENT_BASE_URL']

        super
      end

      # Overrides ruby's method_missing to allow creation of URLs through method calls.
      #
      # @example Adding a simple URL part
      #   request = Parliament::Request::UrlRequest.new(base_url: 'http://example.com')
      #
      #   # url: http://example.com/people
      #   request.people
      #
      # @example Adding a simple URL part with parameters
      #   request = Parliament::Request::UrlRequest.new(base_url: 'http://example.com')
      #
      #   # url: http://example.com/people/123456
      #   request.people('123456')
      #
      # @example Chaining URL parts and using hyphens
      #   request = Parliament::Request::UrlRequest.new(base_url: 'http://example.com')
      #
      #   # url: http://example.com/people/123456/foo/bar/hello-world/7890
      #   request.people('123456').foo.bar('hello-world', '7890')
      #
      # @param [Symbol] method the 'method' (url part) we are processing.
      # @param [Array<Object>] params parameters passed to the specified method (url part).
      # @param [Block] block additional block (kept for compatibility with method_missing API).
      #
      # @return [Parliament::Request::UrlRequest] self.
      def method_missing(method, *params, &block)
        @endpoint_parts << method.to_s
        @endpoint_parts << params
        @endpoint_parts = @endpoint_parts.flatten!

        block&.call

        self || super
      end

      # This class always responds to method calls, even those missing. Therefore, respond_to_missing? always returns true.
      #
      # @return [Boolean] always returns true.
      def respond_to_missing?(_, _ = false)
        true # responds to everything, always
      end

      private

      def query_url
        [@base_url, @endpoint_parts].join('/')
      end
    end
  end
end
