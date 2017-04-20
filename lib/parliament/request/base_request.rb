module Parliament
  module Request
    # Base request object, allowing the user to make a request to an API.
    #
    # @since 0.7.5
    #
    # @attr_reader [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
    # @attr_reader [Hash] headers the headers being sent in the request.
    class BaseRequest
      attr_reader :base_url, :headers
      # Creates a new instance of Parliament::Request::BaseRequest.
      #
      # An interesting note for #initialize is that setting base_url on the class, or using the environment variable
      # PARLIAMENT_BASE_URL means you don't need to pass in a base_url. You can pass one anyway to override the
      # environment variable or class parameter.  Similarly, headers can be set by either settings the headers on the class, or passing headers in.
      #
      # @example Setting the base_url on the class
      #   Parliament::Request::BaseRequest.base_url = 'http://example.com'
      #
      #   Parliament::Request::BaseRequest.new.base_url #=> 'http://example.com'
      #
      # @example Setting the base_url via environment variable
      #   ENV['PARLIAMENT_BASE_URL'] #=> 'http://test.com'
      #
      #   Parliament::Request::BaseRequest.new.base_url #=> 'http://test.com'
      #
      # @example Setting the base_url via a parameter
      #   Parliament::Request::BaseRequest.base_url #=> nil
      #   ENV['PARLIAMENT_BASE_URL'] #=> nil
      #
      #   Parliament::Request::BaseRequest.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
      #
      # @example Overriding the base_url via a parameter
      #   ENV['PARLIAMENT_BASE_URL'] #=> 'http://test.com'
      #
      #   Parliament::Request::BaseRequest.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
      #
      # @example Setting the headers on the class
      #   Parliament::Request::BaseRequest.headers = { 'Accept' => 'Test' }
      #
      #   Parliament::Request::BaseRequest.new.headers #=> '{ 'Accept' => 'Test' }
      #
      # @example Setting the headers via a parameter
      #   Parliament::Request::BaseRequest.headers #=> nil
      #
      #   Parliament::Request::BaseRequest.new(headers: '{ 'Accept' => 'Test' }).headers #=> { 'Accept' => 'Test' }
      #
      # @example Overriding the headers via a parameter
      #   Parliament::Request::BaseRequest.headers = { 'Accept' => 'Test' }
      #
      #   Parliament::Request::BaseRequest.new(headers: '{ 'Accept' => 'Test2' }).headers #=> { 'Accept' => 'Test2' }
      #
      # @param [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
      # @param [Hash] headers the headers being sent in the request.
      # @param [Parliament::Builder] builder the builder to use in order to build a response.
      # @params [Module] decorators the decorator module to use in order to provide possible alias methods for any objects created by the builder.
      def initialize(base_url: nil, headers: nil, builder: nil, decorators: nil)
        @base_url = base_url || self.class.base_url
        @headers = headers || self.class.headers || {}
        @builder = builder || Parliament::Builder::BaseResponseBuilder
        @decorators = decorators
      end

      # Makes an HTTP GET request and process results into a response.
      #
      # @example HTTP GET request
      #   request = Parliament::Request::BaseRequest.new(base_url: 'http://example.com/people/123'
      #
      #   # url: http://example.com/people/123
      #
      #   response = request.get #=> #<Parliament::Response::BaseResponse ...>
      #
      # @example HTTP GET request with URI encoded form values
      #   request = Parliament::Request.new(base_url: 'http://example.com/people/current')
      #
      #   # url: http://example.com/people/current?limit=10&page=4&lang=en-gb
      #
      #   response = request.get({ limit: 10, page: 4, lang: 'en-gb' }) #=> #<Parliament::Response::BaseResponse ...>
      #
      # @raise [Parliament::ServerError] when the server responds with a 5xx status code.
      # @raise [Parliament::ClientError] when the server responds with a 4xx status code.
      # @raise [Parliament::NoContentResponseError] when the response body is empty.
      #
      # @param [Hash] params (optional) additional URI encoded form values to be added to the URI.
      #
      # @return [Parliament::Response::BaseResponse] a Parliament::Response::BaseResponse object containing all of the data returned from the URL.
      def get(params: nil)
        endpoint_uri = URI.parse(query_url)
        endpoint_uri.query = URI.encode_www_form(params.to_a) unless params.nil?

        http = Net::HTTP.new(endpoint_uri.host, endpoint_uri.port)
        http.use_ssl = true if endpoint_uri.scheme == 'https'

        net_response = http.start do |h|
          api_request = Net::HTTP::Get.new(endpoint_uri.request_uri)
          add_headers(api_request)

          h.request api_request
        end

        handle_errors(net_response)

        build_response(net_response)
      end

      private

      # @attr [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
      # @attr [Hash] headers the headers being sent in the request.
      class << self
        attr_accessor :base_url, :headers
      end

      def build_response(net_response)
        @builder.new(response: net_response, decorators: @decorators).build
      end

      def query_url
        @base_url
      end

      def default_headers
        { 'Accept' => 'application/n-triples' }
      end

      def add_headers(request)
        headers = default_headers.merge(@headers)
        headers.each do |key, value|
          request.add_field(key, value)
        end
      end

      def handle_errors(response)
        case response
        when Net::HTTPSuccess # 2xx Status
          exception_class = Parliament::NoContentResponseError if response.code == '204'
        when Net::HTTPClientError # 4xx Status
          exception_class = Parliament::ClientError
        when Net::HTTPServerError # 5xx Status
          exception_class = Parliament::ServerError
        end

        raise exception_class.new(query_url, response) if exception_class
      end
    end
  end
end
