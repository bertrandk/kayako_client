module KayakoClient
    module HTTP

        def self.included(base)
            base.extend(ClassMethods)
        end

        def proxy=(options = {})
            @proxy = {}
            options.each do |key, value|
                if [ :host, :port, :user, :pass ].include?(key)
                    @proxy[key] = value
                else
                    raise ArgumentError, "unsupported option: #{key}"
                end
            end
        end

        def proxy
            @proxy ||= self.class.proxy
        end

        def http_backend=(backend)
            if backend.is_a?(String)
                raise ArgumentError, "invalid HTTP backend: #{backend}" unless backend =~ /^[A-Za-z_]+$/
                file = backend.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/([A-Z])([A-Z][a-z])/, '\1_\2').downcase
                require "kayako_client/http/#{file}"
                backend = KayakoClient.const_get(backend)
            end
            if backend.is_a?(Class)
                if backend.included_modules.include?(KayakoClient::HTTPBackend)
                    @http_backend = backend
                    @client = nil
                else
                    raise ArgumentError, "invalid HTTP backend: #{backend.name}"
                end
            else
                if backend.class.included_modules.include?(KayakoClient::HTTPBackend)
                    @http_backend = backend.class
                    @client = backend
                else
                    raise ArgumentError, "invalid HTTP backend: #{backend.class.name}"
                end
            end
        end

        def http_backend
            @http_backend ||= self.class.http_backend
        end

        def client
            @client ||= nil
            unless @client
                if !instance_of?(KayakoClient::Base) && http_backend == self.class.http_backend && self.class.client
                    @client = self.class.client
                else
                    @client = http_backend.new(proxy.merge(:logger => logger))
                end
            end
            @client
        end

        def put_request(params = {})
            @errors ||= {}
            raise RuntimeError, "undefined ID" unless id
            random = self.class.salt
            e = params.delete(:e) || "#{self.class.path}/#{id}"
            data = self.class.validate(params.merge(:errors => @errors))
            if @errors.empty?
                client.put(api_url, data.merge(:e         => e,
                                               :apikey    => api_key,
                                               :salt      => random,
                                               :signature => self.class.signature(random, secret_key)))
            else
                @errors
            end
        end

        def post_request(params = {})
            @errors ||= {}
            random = self.class.salt
            e = params.delete(:e) || self.class.path
            data = self.class.validate(params.merge(:errors => @errors))
            if @errors.empty?
                client.post(api_url, data.merge(:e         => e,
                                                :apikey    => api_key,
                                                :salt      => random,
                                                :signature => self.class.signature(random, secret_key)))
            else
                @errors
            end
        end

        def delete_request(params = {})
            raise RuntimeError, "undefined ID" unless id
            random = self.class.salt
            e = params.delete(:e) || "#{self.class.path}/#{id}"
            client.delete(api_url, :e         => e,
                                   :apikey    => api_key,
                                   :salt      => random,
                                   :signature => self.class.signature(random, secret_key))
        end

        module ClassMethods

            def proxy=(options = {})
                @@proxy = {}
                options.each do |key, value|
                    if [ :host, :port, :user, :pass ].include?(key)
                        @@proxy[key] = value
                    else
                        raise ArgumentError, "unsupported option: #{key}"
                    end
                end
            end

            def proxy
                @@proxy ||= {}
            end

            def http_backend=(backend)
                if backend.is_a?(String)
                    raise ArgumentError, "invalid HTTP backend: #{backend}" unless backend =~ /^[A-Za-z_]+$/
                    file = backend.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/([A-Z])([A-Z][a-z])/, '\1_\2').downcase
                    require "kayako_client/http/#{file}"
                    backend = KayakoClient.const_get(backend)
                end
                if backend.is_a?(Class)
                    if backend.included_modules.include?(KayakoClient::HTTPBackend)
                        @@http_backend = backend
                        @@client = nil
                    else
                        raise ArgumentError, "invalid HTTP backend: #{backend.name}"
                    end
                else
                    if backend.class.included_modules.include?(KayakoClient::HTTPBackend)
                        @@http_backend = backend.class
                        @@client = backend
                    else
                        raise ArgumentError, "invalid HTTP backend: #{backend.class.name}"
                    end
                end
            end

            def http_backend
                begin
                    require 'kayako_client/http/http_client'
                    @@http_backend ||= KayakoClient::HTTPClient
                rescue LoadError
                    require 'kayako_client/http/net_http'
                    @@http_backend ||= KayakoClient::NetHTTP
                end
            end

            def client
                @@client ||= nil
                unless @@client
                    @@client = http_backend.new(proxy.merge(:logger => logger))
                end
                @@client
            end

            def get_request(options = {})
                random = salt
                params = options.dup

                id     = params.delete(:id)
                e      = params.delete(:e) || (id.nil? ? path : "#{path}/#{id}")
                http   = params.delete(:client) || client
                url    = params.delete(:api_url) || api_url
                key    = params.delete(:api_key) || api_key
                secret = params.delete(:secret_key) || secret_key

                http.get(url, params.merge(:e         => e,
                                           :apikey    => key,
                                           :salt      => random,
                                           :signature => signature(random, secret)))
            end

            def post_request(options = {})
                random = salt
                params = options.dup

                e      = params.delete(:e) || path
                http   = params.delete(:client) || client
                url    = params.delete(:api_url) || api_url
                key    = params.delete(:api_key) || api_key
                secret = params.delete(:secret_key) || secret_key

                http.post(url, params.merge(:e         => e,
                                            :apikey    => key,
                                            :salt      => random,
                                            :signature => signature(random, secret)))
            end

            def delete_request(options = {})
                random = salt
                params = options.dup

                id     = params.delete(:id)
                e      = params.delete(:e) || "#{path}/#{id}"
                http   = params.delete(:client) || client
                url    = params.delete(:api_url) || api_url
                key    = params.delete(:api_key) || api_key
                secret = params.delete(:secret_key) || secret_key

                raise ArgumentError, "missing ID" unless id
                http.delete(url, :e         => e,
                                 :apikey    => key,
                                 :salt      => random,
                                 :signature => signature(random, secret))
            end

        end

    end
end
