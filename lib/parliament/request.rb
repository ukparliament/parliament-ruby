module Parliament
  # Namespace for classes and modules that handle http connections.
  # @since 0.7.0
  module Request
    Dir[File.join(File.dirname(__FILE__), '../parliament/request', '*.rb')].each { |request| require request }
    # Currently just a namespace definition
  end
end
