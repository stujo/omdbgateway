require 'omdbgateway/gateway'
require 'omdbgateway/response_patcher'
require 'omdbgateway/response_wrapper'

module OMDBGateway
  DEFAULT_API_ENDPOINT = 'http://omdbapi.com'

  @@gateways = {}

  def self.gateway endpoint = nil
    endpoint = DEFAULT_API_ENDPOINT if endpoint.nil?
    @@gateways[endpoint] = Gateway.new(endpoint) unless @@gateways.key? endpoint
    @@gateways[endpoint]
  end
end

