module OMDBGateway
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
end