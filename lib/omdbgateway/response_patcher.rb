module OMDBGateway
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
end