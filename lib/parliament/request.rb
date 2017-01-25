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
      response = Net::HTTP.get_response(URI(api_endpoint))

      raise StandardError, 'This is a HTTPClientError' if response.is_a?(Net::HTTPClientError)
      raise StandardError, 'This is a HTTPServerError' if response.is_a?(Net::HTTPServerError)

      Parliament::Response.new(Grom::Reader.new(response.body).objects)
    end

    private

    class << self
      attr_accessor :base_url
    end

    def api_endpoint
      [@base_url, @endpoint_parts].join('/') + '.nt'
    end
  end
end
