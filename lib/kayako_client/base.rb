module KayakoClient

    class Base
        include KayakoClient::API
        include KayakoClient::Logger
        include KayakoClient::Object
        include KayakoClient::Authentication
        include KayakoClient::HTTP
        include KayakoClient::XML

        def initialize(*args)
            options = args.last.is_a?(Hash) ? args.pop : {}

            if args[0]
                @api_url = args[0]
            elsif options.has_key?(:api_url)
                @api_url = options.delete(:api_url)
            else
                @api_url = Base.api_url
            end

            if args[1]
                @api_key = args[1]
            elsif options.has_key?(:api_key)
                @api_key = options.delete(:api_key)
            else
                @api_key = Base.api_key
            end

            if args[2]
                @secret_key = args[2]
            elsif options.has_key?(:secret_key)
                @secret_key = options.delete(:secret_key)
            else
                @secret_key = Base.secret_key
            end

            if options.has_key?(:client)
                http = options.delete(:client)
                if http
                    if http.class.included_modules.include?(KayakoClient::HTTPBackend)
                        @http_backend = http.class
                        @client = http
                    else
                        raise ArgumentError, "invalid HTTP client: #{http.class.name}"
                    end
                end
            end

            if options.has_key?(:logger)
                @logger = options.delete(:logger)
            end

            if self.instance_of?(KayakoClient::Base)
                unless defined?(@client) && @client
                    @client = http_backend.new(proxy.merge(:logger => logger))
                end
                self.extend(KayakoClient::Client)
            end

            @associated = {}
            import(options)
        end

        def inherited_options
            inherited = {}
            inherited[:api_url]    = @api_url    if defined?(@api_url)
            inherited[:api_key]    = @api_key    if defined?(@api_key)
            inherited[:secret_key] = @secret_key if defined?(@secret_key)
            inherited[:client]     = @client     if defined?(@client)
            inherited[:logger]     = @logger     if defined?(@logger)
            inherited
        end

        class << self

            def configure(&block)
                instance_eval(&block)
            end

            def inherited_options(options)
                inherited = {}
                inherited[:api_url]    = options[:api_url]    if options.has_key?(:api_url)
                inherited[:api_key]    = options[:api_key]    if options.has_key?(:api_key)
                inherited[:secret_key] = options[:secret_key] if options.has_key?(:secret_key)
                inherited[:client]     = options[:client]     if options.has_key?(:client)
                inherited[:logger]     = options[:logger]     if options.has_key?(:logger)
                inherited
            end

        end

    end

    class Tickets < Base
    end

end
