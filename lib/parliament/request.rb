module Parliament
  # API request object, allowing the user to build a request to a graph-based API, download n-triple data and create
  # ruby objects from that data.
  #
  # @since 0.1.0
  #
  # @attr_reader [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
  class Request
    attr_reader :base_url

    # Creates a new instance of Parliament::Request.
    #
    # An interesting note for #initialize is that setting base_url on the class, or using the environment variable
    # PARLIAMENT_BASE_URL means you don't need to pass in a base_url. You can pass one anyway to override the
    # environment variable or class parameter.
    #
    # @example Setting the base_url on the class
    #   Parliament::Request.base_url = 'http://example.com'
    #
    #   Parliament::Request.new.base_url #=> 'http://example.com'
    #
    # @example Setting the base_url via environment variable
    #   ENV['PARLIAMENT_BASE_URL'] #=> 'http://test.com'
    #
    #   Parliament::Request.new.base_url #=> 'http://test.com'
    #
    # @example Setting the base_url via a parameter
    #   Parliament::Request.base_url #=> nil
    #   ENV['PARLIAMENT_BASE_URL'] #=> nil
    #
    #   Parliament::Request.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
    #
    # @example Overriding the base_url via a parameter
    #   ENV['PARLIAMENT_BASE_URL'] #=> 'http://test.com'
    #
    #   Parliament::Request.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
    #
    # @param [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
    def initialize(base_url: nil)
      @endpoint_parts = []
      @base_url = base_url || self.class.base_url || ENV['PARLIAMENT_BASE_URL']
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

    # Using our url built via #method_missing, make a HTTP GET request and process results into a response.
    #
    # @example HTTP GET request
    #   request = Parliament::Request.new(base_url: 'http://example.com')
    #
    #   # url: http://example.com/people/123456
    #   response = request.people('123456').get #=> #<Parliament::Response ...>
    #
    # @example HTTP GET request with URI encoded form values
    #   request = Parliament::Request.new(base_url: 'http://example.com')
    #
    #   # url: http://example.com/people/current?limit=10&page=4&lang=en-gb
    #   response = request.people.current.get({ limit: 10, page: 4, lang: 'en-gb' }) #=> #<Parliament::Response ...>
    #
    # @raise [Parliament::ServerError] when the server responds with a 5xx status code.
    # @raise [Parliament::ClientError] when the server responds with a 4xx status code.
    # @raise [Parliament::NoContentResponseError] when the server responds with a 204 status code.
    #
    # @param [Hash] params (optional) additional URI encoded form values to be added to the URI.
    #
    # @return [Parliament::Response] a Parliament::Response object containing all of the nodes returned from the URL.
    def get(params: nil)
      endpoint_uri = URI.parse(api_endpoint)
      endpoint_uri.query = URI.encode_www_form(params.to_a) unless params.nil?

      request = Net::HTTP::Get.new(URI(endpoint_uri))
      request.add_field('Accept', 'application/n-triples')

      net_response = Net::HTTP.new(endpoint_uri.host, endpoint_uri.port).start do |http|
        http.request(request)
      end

      handle_errors(net_response)

      build_parliament_response(net_response)
    end

    private

    # @attr [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
    class << self
      attr_accessor :base_url
    end

    def api_endpoint
      [@base_url, @endpoint_parts].join('/')
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

      raise exception_class.new(api_endpoint, response) if exception_class
    end

    def build_parliament_response(response)
      objects = Grom::Reader.new(response.body).objects
      objects.map { |object| assign_decorator(object) }

      Parliament::Response.new(objects)
    end

    def assign_decorator(object)
      return object unless object.respond_to?(:type)

      object_type = Grom::Helper.get_id(object.type)

      return object unless Parliament::Decorator.constants.include?(object_type.to_sym)

      decorator_module = Object.const_get("Parliament::Decorator::#{object_type}")
      object.extend(decorator_module)
    end
  end
end
