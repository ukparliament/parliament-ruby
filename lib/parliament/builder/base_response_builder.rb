module Parliament
  module Builder
    class BaseResponseBuilder
      def initialize(response)
        @response = response
      end

      def build
        @response
      end
    end
  end
end
