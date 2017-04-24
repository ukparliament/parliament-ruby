module Parliament
  module Builder
    # Base response builder, allowing the user to return the body of an HTTPResponse.
    # @since 0.7.5
    class BaseResponseBuilder
      # Creates a new BaseReponseBuilder.
      # @param [HTTPResponse] response an HTTP response.
      # @param [Module] decorators a namespace which contains modules used to decorate the objects we receive.  It is not used directly by the BaseResponseBuilder, but is there for API completeness.
      def initialize(response:, decorators: nil)
        @response = response
        _ = decorators
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
