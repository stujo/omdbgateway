require 'faraday'
require 'faraday_middleware'

module OMDB

  # Faraday Based Gateway
  class Gateway
    attr_reader :base_uri

    class ResponseWrapper
      attr_reader :http_status, :body, :error_message

      def initialize body, http_status = 200, http_error_message = nil
        @http_status = http_status
        @body = body
        @app_failed = false
        if http_success?
          if @body.instance_of?(Hash)
            if @body.key?('Response') && @body['Response'] == 'False'
              @app_failed = true
              if @body.key?('Error')
                @error_message = @body['Error']
              end
            end
          end
        else
          @error_message = http_error_message
        end
      end

      def http_success?;
        @http_status >= 200 && @http_status < 300
      end

      def app_success?
        !@app_failed
      end

      def success?;
        http_success? && app_success?
      end

      def as_hash
        if success? && @body.instance_of?(Hash)
          @body
        else
          {}
        end
      end

      def as_array
        if success? && @body.instance_of?(Array)
          @body
        else
          []
        end
      end

      def prune_hash tag, default = nil
        if as_hash.has_key? tag
          @body = as_hash[tag]
        else
          @body = default
        end
        self
      end

      def prune_array index, default = nil
        if as_array.length > index
          @body = as_array[index]
        else
          @body = default
        end
        self
      end

      def array_first default = nil
        if !as_array.empty?
          as_array[0]
        else
          default
        end
      end
    end


    class ResponsePatcher < Faraday::Response::Middleware
      def call(env)
        begin
          @app.call(env)
          ResponseWrapper.new(env[:body], env[:status])
        rescue Faraday::Error::ConnectionFailed => e
          ResponseWrapper.new(nil, 500, "Connection Failed: #{e}")
        end
      end
    end

    if Faraday.respond_to? :register_middleware
      Faraday.register_middleware :response,
                                  :omdb_gateway => lambda { ResponsePatcher }
    end

    def initialize base_uri
      @base_uri = base_uri
      @conn = Faraday.new(:url => @base_uri) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :omdb_gateway
        faraday.response :json
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
    end

    def get url, &block
      begin
        response = @conn.get do |req|
          req.url url
          yield req if block_given?
        end
      rescue URI::BadURIError => e
        response = ResponseWrapper.new(nil, 500, "BadURIError: #{e}")
      end
      response
    end


    # Retrieves a movie or show based on its title.
    #
    # @param title [String] The title of the movie or show.
    # @param year [String] The year of the movie or show.
    # @param plot [String] The plot of the movie or show.
    # @return [Hash]
    # @example
    #   title_search('Game of Thrones')
    def title_search(title, year = nil, plot = nil)
      response = get '/' do |req|
        req.params = {t: title}
        req.params[:plot] = plot unless plot.nil?
        req.params[:y] = year unless year.nil?
      end
      # Middleware creates the Hash
      response
    end

    # Retrieves a movie or show based on its title.
    #
    # @param q [String] The search string
    # @return [Array of Hashes]
    # @example
    #   free_search('Game')
    def free_search(q)
      response = get '/' do |req|
        req.params = {s: q}
      end
      response.prune_hash('Search', [])
    end


    # Retrieves a movie or show based on its IMDb ID.
    #
    # @param imdb_id [String] The IMDb ID of the movie or show.
    # @return [Hash]
    # @example
    #   find_by_id('tt0944947')
    def find_by_id(imdb_id)
      response = get '/' do |req|
        req.params = {i: imdb_id}
      end
      response
    end
  end
end