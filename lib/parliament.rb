require 'net/http'
require 'grom'

require 'parliament/version'
require 'parliament/request'
require 'parliament/response'

# require all the decorators
Dir[File.join(File.dirname(__FILE__), 'parliament/decorators', '*.rb')].each { |decorator| require decorator }

module Parliament
  # Your code goes here...
end
