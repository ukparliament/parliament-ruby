module Parliament
  module Builder
    # API response builder, allowing the user to return the body of an HTTPResponse.
    # @since 0.7.5
    class BaseResponseBuilder
      # Creates a new BaseReponseBuilder.
      # @param [HTTPResponse] response an HTTP response containing n-triple data.
      # @param [Module] decorators the decorator modules to provide alias methods to the resulting objects.
      def initialize(response:, decorators: nil)
        @response = response
        @decorators = decorators
      end

      # Builds a Parliament::Response::BaseResponse.
      #
      # @return [Parliament::Response::Base::Response] a Parliament::Response::BaseResponse containing the HTTPResponse.
      def build
        Parliament::Response::BaseResponse.new(@response)
      end
    end
  end
end
