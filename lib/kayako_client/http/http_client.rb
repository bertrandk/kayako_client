require 'httpclient'

module KayakoClient
    class HTTPClient
        include KayakoClient::Logger
        include KayakoClient::HTTPBackend

        def initialize(options = {})
            @client = ::HTTPClient.new
            if options[:host]
                @client.proxy = "http://#{options[:host]}:#{options[:port] || 80}"
                @client.set_proxy_auth(options[:user], options[:pass])
            end
            @logger = options[:logger] if options[:logger]
        end

        def get(base, params = {})
            log = params.delete(:logger) || logger
            log.debug ":get => #{base} + #{params.inspect}" if log
            resp = @client.request(:get, base, params)
            response(resp)
        end

        def put(base, params = {})
            query = { :e => params.delete(:e) }
            data = form_data(params)
            log = params.delete(:logger) || logger
            if log
                log.debug ":put => #{base} + #{query.inspect}"
                log.debug "PUT Data: #{data.inspect}"
            end
            resp = @client.request(:put, base, query, data, { 'Content-Type' => 'application/x-www-form-urlencoded' })
            response(resp)
        end

        def post(base, params = {})
            query = { :e => params.delete(:e) }
            data = form_data(params)
            log = params.delete(:logger) || logger
            if log
                log.debug ":post => #{base} + #{query.inspect}"
                log.debug "POST Data: #{data.inspect}"
            end
            resp = @client.request(:post, base, query, data, { 'Content-Type' => 'application/x-www-form-urlencoded' })
            response(resp)
        end

        def delete(base, params = {})
            log = params.delete(:logger) || logger
            log.debug ":delete => #{base} + #{params.inspect}" if log
            resp = @client.request(:delete, base, params)
            response(resp)
        end

        def response(resp)
            case resp.status
            when 200
                KayakoClient::HTTPOK.new(resp.content)
            when 400
                KayakoClient::HTTPBadRequest.new(resp.content)
            when 401
                KayakoClient::HTTPUnauthorized.new(resp.content)
            when 403
                KayakoClient::HTTPForbidden.new(resp.content)
            when 404
                KayakoClient::HTTPNotFound.new(resp.content)
            when 405
                KayakoClient::HTTPNotAllowed.new(resp.content)
            else
                KayakoClient::HTTPResponse.new(resp.status, resp.content)
            end
        end

    private

        def form_data(params = {})
            params.inject([]) do |array, (name, value)|
                if value.is_a?(Array)
                    array.concat(value.collect { |item| [ name.to_s + '[]', item.to_s ] })
                else
                    array.push([ name.to_s, value.to_s ])
                end
            end
        end

    end
end
