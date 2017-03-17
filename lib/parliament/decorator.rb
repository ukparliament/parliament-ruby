module Parliament
  # Decorator namespace
  module Decorator
    # require all the decorators
    Dir[File.join(File.dirname(__FILE__), '../parliament/decorators', '*.rb')].each { |decorator| require decorator }
  end
end
