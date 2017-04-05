require 'feedjira'

module Parliament
  module Builder
    class OpenSearchResponseBuilder < Parliament::Builder::BaseResponseBuilder
      OPEN_SEARCH_ELEMENTS = %w(totalResults Query startIndex itemsPerPage).freeze

      def build
        OPEN_SEARCH_ELEMENTS.each do |element|
          Feedjira::Feed.add_common_feed_element(element)
        end

        Feedjira::Feed.parse(@response.body)
      end
    end
  end
end
