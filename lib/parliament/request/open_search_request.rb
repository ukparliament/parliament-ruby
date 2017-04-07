module Parliament
  module Request
    class OpenSearchRequest < Parliament::Request::BaseRequest
      OPEN_SEARCH_PARAMETERS = {
          count:            10,
          start_index:      1,
          start_page:       1,
          language:         '*',
          output_encoding:  'UTF-8',
          input_encoding:   'UTF-8'
      }.freeze

      def initialize(base_url: nil, headers: nil, builder: nil)
        @base_url = Parliament::Request::OpenSearchRequest.get_description(base_url) || self.class.base_url
        @open_search_parameters = self.class.open_search_parameters

        super(base_url: @base_url, headers: headers, builder: builder)
      end

      def get(search_params, params: nil)
        setup_query_url(search_params)

        super(params: params)
      end

      private

      class << self
        attr_reader :base_url, :open_search_parameters

        def base_url=(base_url)
          @base_url = get_description(base_url)
        end

        def open_search_parameters
          OPEN_SEARCH_PARAMETERS.dup
        end

        def get_description(url)
          return if url.nil?

          request = Parliament::Request::BaseRequest.new(base_url: url,
                                                         headers: { 'Accept' => 'application/opensearchdescription+xml' })
          xml_response = request.get

          xml_root = REXML::Document.new(xml_response.body).root
          xml_root.elements['Url'].attributes['template']
        end
      end

      def query_url
        @query_url
      end

      def setup_query_url(search_params)
        search_terms = search_params[:query]
        query_url = @base_url.dup
        query_url.gsub!('{searchTerms}', search_terms)

        @open_search_parameters.each do |key, value|
          camel_case_key = ActiveSupport::Inflector.camelize(key.to_s, false)
          if search_params.keys.include?(key)
            query_url.gsub!("{#{camel_case_key}?}", search_params[key].to_s)
          else
            query_url.gsub!("{#{camel_case_key}?}", value.to_s)
          end
        end

        @query_url = query_url
      end
    end
  end
end
