require 'typhoeus'

module Parliament
  module Request
    # Base request object, allowing the user to make a request to an API.
    #
    # @since 0.7.5
    #
    # @attr_reader [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
    # @attr_reader [Hash] headers the headers being sent in the request.
    class BaseRequest
      attr_reader :base_url, :headers, :query_params
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
        @base_url     = base_url || self.class.base_url
        @headers      = headers || self.class.headers || {}
        @builder      = builder || Parliament::Builder::BaseResponseBuilder
        @decorators   = decorators
        @query_params = {}
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
        Typhoeus::Config.user_agent = 'Ruby'

        uri_hash = separate_uri(query_url, @query_params, params)

        typhoeus_request = Typhoeus::Request.new(
          uri_hash[:endpoint],
          method:          :get,
          params:          uri_hash[:params],
          headers:         headers,
          accept_encoding: 'gzip'
        )

        response = typhoeus_request.run

        handle_errors(response)

        build_response(response)
      end

      # Makes an HTTP POST request and process results into a response.
      #
      # @example HTTP POST request
      #   request = Parliament::Request::BaseRequest.new(base_url: 'http://example.com/people/123', headers: {'Content': 'application/json', 'Accept': 'application/json'})
      #
      #   # url: http://example.com/people/123
      #
      #   response = request.post(body: {}.to_json) #=> #<Parliament::Response::BaseResponse ...>
      #
      # @example HTTP POST request with URI encoded form values
      #   request = Parliament::Request::BaseRequest.new(base_url: 'http://example.com/people/current', headers: {'Content': 'application/json', 'Accept': 'application/json'})
      #
      #   # url: http://example.com/people/current?limit=10&page=4&lang=en-gb
      #
      #   response = request.post({ limit: 10, page: 4, lang: 'en-gb' }, body: {}.to_json) #=> #<Parliament::Response::BaseResponse ...>
      #
      # @raise [Parliament::ServerError] when the server responds with a 5xx status code.
      # @raise [Parliament::ClientError] when the server responds with a 4xx status code.
      # @raise [Parliament::NoContentResponseError] when the response body is empty.
      #
      # @param [Hash] params (optional) additional URI encoded form values to be added to the URI.
      # @param [String] body (optional) body of the post request.
      # @param [Integer] timeout (optional) a Net::HTTP.read_timeout value passed suring the post.
      #
      # @return [Parliament::Response::BaseResponse] a Parliament::Response::BaseResponse object containing all of the data returned from the URL.
      def post(params: nil, body: nil, timeout: 60)
        Typhoeus::Config.user_agent = 'Ruby'

        uri_hash = separate_uri(query_url, @query_params, params)

        typhoeus_request = Typhoeus::Request.new(
          uri_hash[:endpoint],
          method:          :post,
          params:          uri_hash[:params],
          headers:         headers.merge({ 'Content-Type' => 'application/json' }),
          accept_encoding: 'gzip',
          timeout:         timeout,
          body:            body
        )

        response = typhoeus_request.run

        handle_errors(response)

        build_response(response)
      end

      private

      # @attr [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
      # @attr [Hash] headers the headers being sent in the request.
      class << self
        attr_accessor :base_url, :headers
      end

      def build_response(response)
        @builder.new(response: response, decorators: @decorators).build
      end

      def query_url
        @base_url
      end

      def default_headers
        { 'Accept' => ['*/*', 'application/n-triples'] }
      end

      def headers
        default_headers.merge(@headers)
      end

      def handle_errors(response)
        exception_class = if response.success? # 2xx Status
                            Parliament::NoContentResponseError if response.headers&.[]('Content-Length') == '0' ||
                              (response.headers&.[]('Content-Length').nil? && response.body.empty?)
                          elsif /\A4\w{2}/.match(response.code.to_s) # 4xx Status
                            Parliament::ClientError
                          elsif /\A5\w{2}/.match(response.code.to_s) # 5xx Status
                            Parliament::ServerError
                          end

        raise exception_class.new(query_url, response) if exception_class
      end

      def separate_uri(query_url, query_params, additional_params)
        endpoint = URI.parse(query_url)

        temp_params = query_params
        temp_params = temp_params.merge(URI.decode_www_form(endpoint.query)) if endpoint.query
        temp_params = temp_params.merge(additional_params) unless additional_params.nil?

        endpoint.query = nil

        encoded_params = URI.encode_www_form(temp_params.to_a) unless temp_params.empty?

        { endpoint: endpoint, params: encoded_params }
      end
    end
  end
end

