require 'faraday'
require 'faraday_middleware'

module OMDB

  # Faraday Based Gateway
  class Gateway
    attr_reader :base_uri

    if Faraday.respond_to? :register_middleware
      Faraday.register_middleware :response,
                                  :omdb => lambda { ResponseMiddleware }
    end

    def initialize base_uri
      @base_uri = base_uri
      @conn = Faraday.new(:url => @base_uri) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :json
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
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
      response = @conn.get do |req|
        req.url '/'
        req.params = {t: title}
        req.params[:plot] = plot unless plot.nil?
        req.params[:y] = year unless year.nil?
      end
      # Middleware creates the Hash
      response.body
    end

    # Retrieves a movie or show based on its title.
    #
    # @param q [String] The search string
    # @return [Array of Hashes]
    # @example
    #   free_search('Game')
    def free_search(q)
      response = @conn.get do |req|
        req.url '/'
        req.params = {s: q}
      end
      # Middleware creates the Hash
      results = response.body
      if results.key? 'Search'
        results['Search']
      else
        []
      end
    end

    # Retrieves a movie or show based on its IMDb ID.
    #
    # @param imdb_id [String] The IMDb ID of the movie or show.
    # @return [Hash]
    # @example
    #   find_by_id('tt0944947')
    def find_by_id(imdb_id)
      response = @conn.get do |req|
        req.url '/'
        req.params = {i: imdb_id}
      end
      if response.body.key? 'Error'
        nil
      else
        response.body
      end
    end
  end
end