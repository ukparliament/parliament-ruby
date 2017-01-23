require 'forwardable'

module Parliament
  class Response
    include Enumerable
    extend Forwardable
    attr_reader :nodes
    def_delegators :@nodes, :size, :each, :select, :map, :select!, :map!, :count, :length

    def initialize(nodes)
      @nodes = nodes
    end

    def filter(*types)
      filtered_objects = Array.new(types.size, [])

      @nodes.each do |node|
        type_index = types.index(node.type)

        filtered_objects[type_index] << node unless type_index.nil?
      end

      filtered_objects.map do |objects|
        Parliament::Response.new(objects)
      end
    end
  end
end