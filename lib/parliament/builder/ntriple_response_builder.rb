module Parliament
  module Builder
    class NTripleResponseBuilder < Parliament::Builder::BaseResponseBuilder
      def build
        objects = Grom::Reader.new(@response.body).objects
        objects.map { |object| assign_decorator(object) }

        Parliament::Response.new(objects)
      end

      private

      def assign_decorator(object)
        return object unless object.respond_to?(:type)

        object_type = Grom::Helper.get_id(object.type)

        return object unless Parliament::Decorator.constants.include?(object_type.to_sym)

        decorator_module = Object.const_get("Parliament::Decorator::#{object_type}")
        object.extend(decorator_module)
      end
    end
  end
end
