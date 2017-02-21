module Parliament
  class Request
    attr_reader :base_url

    def initialize(base_url: nil)
      @endpoint_parts = []
      @base_url = base_url || self.class.base_url || ENV['PARLIAMENT_BASE_URL']
    end

    def method_missing(method, *params, &block)
      # TODO: Fix this smell
      super if method == :base_url=

      @endpoint_parts << method.to_s
      @endpoint_parts << params
      @endpoint_parts = @endpoint_parts.flatten!
      self
    end

    def respond_to_missing?(method, include_private = false)
      (method != :base_url=) || super
    end

    def get
      net_response = Net::HTTP.get_response(URI(api_endpoint))

      handle_errors(net_response)

      build_parliament_response(net_response)
    end

    def build_parliament_response(response)
      objects = Grom::Reader.new(response.body).objects
      objects.map { |object| assign_decorator(object) }

      Parliament::Response.new(objects)
    end

    def handle_errors(response)
      handle_not_found_error(response)
      handle_server_error(response)
      handle_no_content_error(response)
    end

    def handle_server_error(response)
      raise StandardError, 'This is a HTTPServerError' if response.is_a?(Net::HTTPServerError)
    end

    def handle_not_found_error(response)
      raise StandardError, 'This is a HTTPClientError' if response.is_a?(Net::HTTPClientError)
    end

    def handle_no_content_error(response)
      raise Parliament::NoContentError if response.code == '204'
    end

    def assign_decorator(object)
      object_type = Grom::Helper.get_id(object.type)
      return object unless Parliament::Decorators.constants.include?(object_type.to_sym)
      decorator_module = Object.const_get("Parliament::Decorators::#{object_type}")
      object.extend(decorator_module)
    end

    private

    class << self
      attr_accessor :base_url
    end

    def api_endpoint
      [@base_url, @endpoint_parts].join('/')
    end
  end
end
