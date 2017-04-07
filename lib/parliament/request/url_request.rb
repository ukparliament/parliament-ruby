module Parliament
  module Request
    class UrlRequest < Parliament::Request::BaseRequest
      def initialize(base_url: nil, headers: nil, builder: nil)
        @endpoint_parts = []
        base_url ||= ENV['PARLIAMENT_BASE_URL']

        super
      end

      # Overrides ruby's method_missing to allow creation of URLs through method calls.
      #
      # @example Adding a simple URL part
      #   request = Parliament::Request.new(base_url: 'http://example.com')
      #
      #   # url: http://example.com/people
      #   request.people
      #
      # @example Adding a simple URL part with parameters
      #   request = Parliament::Request.new(base_url: 'http://example.com')
      #
      #   # url: http://example.com/people/123456
      #   request.people('123456')
      #
      # @example Chaining URL parts and using hyphens
      #   request = Parliament::Request.new(base_url: 'http://example.com')
      #
      #   # url: http://example.com/people/123456/foo/bar/hello-world/7890
      #   request.people('123456').foo.bar('hello-world', '7890')
      #
      # @param [Symbol] method the 'method' (url part) we are processing.
      # @param [Array<Object>] params parameters passed to the specified method (url part).
      # @param [Block] block additional block (kept for compatibility with method_missing API).
      #
      # @return [Parliament::Request] self.
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
