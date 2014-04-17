require 'faraday'
require 'faraday_middleware'

require_relative 'response_wrapper'
require_relative 'response_patcher'

module OMDBGateway
  # Faraday Based Gateway
  class Gateway
    attr_reader :base_uri

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