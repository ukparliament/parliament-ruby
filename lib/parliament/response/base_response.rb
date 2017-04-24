module Parliament
  module Response
    # An API response built from API data.
    #
    # @since 0.7.5.
    # @attr_reader [HTTPResponse] response the HTTPResponse from the API.
    class BaseResponse
      attr_reader :response

      # Creates a Parliament::BaseResponse object.
      #
      # @param [HTTPResponse] response an HTTPResponse from the API.
      def initialize(response)
        @response = response
      end
    end
  end
end
