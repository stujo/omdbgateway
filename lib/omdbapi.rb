require 'httparty'
require 'json'
require 'omdbapi/version'
require 'omdbapi/default'
require 'omdbapi/gateway'

# Ruby wrapper for omdbapi.com API.
module OMDB

  @@gateways = {}

  # API Gateway for making calls to the omdbapi API.
  #
  # return [OMDB::Gateway] API Gateway
  def self.gateway endpoint = nil
    endpoint = OMDB::Default::API_ENDPOINT if endpoint.nil?
    @@gateways[endpoint] = OMDB::Gateway.new(endpoint) unless @@gateways.key? endpoint
    @@gateways[endpoint]
  end
end

