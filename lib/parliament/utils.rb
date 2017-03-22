module Parliament
  # Namespace for helper methods used with parliament-ruby.
  #
  # @since 0.6.0
  module Utils
    # Sort an Array of Objects in ascending order. The major difference between this implementation of sort_by and the
    # standard one is that our implementation includes objects that return nil for our parameter values.
    #
    # @see Parliament::Utils.reverse_sort_by
    #
    # @example Sorting a list of objects by date
    #   response = parliament.people('123').get.filter('http://id.ukpds.org/schema/Person')
    #
    #   objects = response.first.incumbencies
    #
    #   args = {
    #     list: objects,
    #     parameters: [:endDate],
    #     prepend_rejected: false
    #   }
    #
    #   sorted_list = Parliament::Util.sort_by(args)
    #
    #   sorted_list.each { |incumbency| puts incumbency.respond_to?(:endDate) ? incumbency.endDate : 'Current' }
    #   # http://id.ukpds.org/1121 - 1981-07-31
    #   # http://id.ukpds.org/5678 - 1991-03-15
    #   # http://id.ukpds.org/1234 - 1997-01-01
    #   # http://id.ukpds.org/9101 - 2011-09-04
    #   # http://id.ukpds.org/3141 - Current
    #
    # @param [Hash] args a hash of arguments.
    # @option args [Array<Object>] :list the 'list' which we are sorting.
    # @option args [Array<Symbol>] :parameters an array of parameters we are sorting by.
    # @option args [Boolean] :prepend_rejected (true) should objects that do not respond to our parameters be prepended?
    #
    # @return [Array<Object>] a sorted array of objects using the args passed in.
    def self.sort_by(args)
      rejected = []
      args = sort_defaults.merge(args)
      list = args[:list].dup
      parameters = args[:parameters]

      list, rejected = prune_list(list, rejected, parameters)

      list = sort_list(list, parameters)

      # Any rejected (nil) values will be added to the start of the result unless specified otherwise
      args[:prepend_rejected] ? rejected.concat(list) : list.concat(rejected)
    end

    # Sort an Array of Objects in descending order. Largely, this implementation runs Parliament::Utils.sort_by and
    # calls reverse! on the result.
    #
    # @see Parliament::Utils.sort_by
    #
    # @example Sorting a list of objects by date
    #   response = parliament.people('123').get.filter('http://id.ukpds.org/schema/Person')
    #
    #   objects = response.first.incumbencies
    #
    #   args = {
    #     list: objects,
    #     parameters: [:endDate],
    #     prepend_rejected: false
    #   }
    #
    #   sorted_list = Parliament::Util.reverse_sort_by(args)
    #
    #   sorted_list.each { |incumbency| puts incumbency.respond_to?(:endDate) ? incumbency.endDate : 'Current' }
    #   # http://id.ukpds.org/3141 - Current
    #   # http://id.ukpds.org/9101 - 2011-09-04
    #   # http://id.ukpds.org/1234 - 1997-01-01
    #   # http://id.ukpds.org/5678 - 1991-03-15
    #   # http://id.ukpds.org/1121 - 1981-07-31
    #
    # @param [Hash] args a hash of arguments.
    # @option args [Array<Object>] :list the 'list' which we are sorting.
    # @option args [Array<Symbol>] :parameters an array of parameters we are sorting by.
    # @option args [Boolean] :prepend_rejected (true) should objects that do not respond to our parameters be prepended?
    #
    # @return [Array<Object>] a sorted array of objects using the args passed in.
    def self.reverse_sort_by(args)
      Parliament::Utils.sort_by(args).reverse!
    end

    # Default arguments hash for #sort_by and #reverse_sort_by.
    #
    # @see Parliament::Utils.sort_by
    # @see Parliament::Utils.reverse_sort_by
    #
    # @return [Hash] default arguments used in sorting methods.
    def self.sort_defaults
      { prepend_rejected: true }
    end

    # @!method self.prune_list(list, rejected, parameters)
    # Prune all objects that do not respond to a given array of parameters.
    #
    # @private
    # @!scope class
    # @!visibility private
    #
    # @param [Array<Object>] list the 'list' of objects we are pruning from.
    # @param [Array<Object>] rejected the objects we have pruned from list.
    # @param [Array<Symbol>] parameters an array of parameters we are checking.
    #
    # @return [Array<Array<Object>, Array<Object>>] an array containing first, the pruned list and secondly, the rejected list.
    private_class_method def self.prune_list(list, rejected, parameters)
      list.delete_if do |object|
        rejected << object unless parameters.all? { |param| !object.send(param).nil? if object.respond_to?(param) }
      end

      [list, rejected]
    end

    # @!method self.sort_list(list, parameters)
    # Sort a given list of objects by a list of parameters.
    #
    # @private
    # @!scope class
    # @!visibility private
    #
    # @param [Array<Object>] list the 'list' of objects we are pruning from.
    # @param [Array<Symbol>] parameters an array of parameters we are checking.
    #
    # @return [Array<Object>] our sorted list.
    private_class_method def self.sort_list(list, parameters)
      list.sort_by! do |object|
        parameters.map do |param|
          object.send(param).is_a?(String) ? I18n.transliterate(object.send(param)).downcase : object.send(param)
        end
      end
    end
  end
end
