
module Parliament
  module Decorators
    module Party
      def name
        respond_to?(:partyName) ? partyName : ''
      end
    end
  end
end
