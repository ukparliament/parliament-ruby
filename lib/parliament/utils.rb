module Parliament
  module Utils
    def self.sort_by(args)
      rejected = []
      args = sort_defaults.merge(args)
      list = args[:list].dup
      parameters = args[:parameters]

      list.delete_if do |object|
        rejected << object unless parameters.all? { |param| !object.send(param).nil? if object.respond_to?(param) }
      end

      list.sort_by! do |object|
        parameters.map do |param|
          object.send(param).is_a?(String) ? I18n.transliterate(object.send(param)).downcase : object.send(param)
        end
      end

      # Any rejected (nil) values will be added to the start of the result unless specified otherwise
      args[:prepend_rejected] ? rejected.concat(list) : list.concat(rejected)
    end

    def self.reverse_sort_by(args)
      Parliament::Utils.sort_by(args).reverse!
    end

    private_class_method

    def self.sort_defaults
      {
        prepend_rejected: true
      }
    end
  end
end
