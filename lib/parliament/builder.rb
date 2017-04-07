module Parliament
  module Builder
    Dir[File.join(File.dirname(__FILE__), '../parliament/builder', '*.rb')].each { |builder| require builder }
  end
end
