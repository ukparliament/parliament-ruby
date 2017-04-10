module Parliament
  # Namespace for classes and modules that processes data from http requests.
  # @since 0.7.0
  module Builder
    Dir[File.join(File.dirname(__FILE__), '../parliament/builder', '*.rb')].each { |builder| require builder }
    # Currently just a namespace definition
  end
end
