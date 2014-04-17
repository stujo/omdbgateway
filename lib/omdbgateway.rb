require 'omdbgateway/gateway'

module OMDBGateway
  DEFAULT_API_ENDPOINT = 'http://omdbapi.com'

  @@gateways = {}

  def self.gateway endpoint = nil
    endpoint = DEFAULT_API_ENDPOINT if endpoint.nil?
    @@gateways[endpoint] = Gateway.new(endpoint) unless @@gateways.key? endpoint
    @@gateways[endpoint]
  end
end

