module KayakoClient
    module API

        def self.included(base)
            base.extend(ClassMethods)
        end

        def api_url=(url)
            @api_url = url
        end

        def api_url
            @api_url ||= self.class.api_url
        end

        def api_key=(key)
            @api_key = key
        end

        def api_key
            @api_key ||= self.class.api_key
        end

        def secret_key=(secret)
            @secret_key = secret
        end

        def secret_key
            @secret_key ||= self.class.secret_key
        end

        def put
            raise NotImplementedError, "method not supported" unless self.class.support?(:put)
            raise RuntimeError, "client not configured" unless configured?
            if changed?
                params = changes.inject({}) do |hash, property|
                    hash[property] = instance_variable_get("@#{property}")
                    hash
                end
                require_properties(:put, params)
                validate(:put, params)
                check_conditions(params)
                response = put_request(params)
                if response.is_a?(KayakoClient::HTTPOK)
                    if logger
                        logger.debug "Response:"
                        logger.debug response.body
                    end
                    payload = xml_backend.new(response.body, { :logger => logger })
                    clean
                    import(payload.to_hash)
                    loaded!
                    logger.info ":put successful for object##{id}" if logger
                    true
                else
                    unless response.is_a?(Hash)
                        logger.error "Response: #{response.status} #{response.body}" if logger
                        raise StandardError, "server returned #{response.status}: #{response.body}"
                    end
                    false
                end
            else
                logger.warn "nothing to :put" if logger
                true
            end
        end

        alias_method :update, :put

        def post
            raise NotImplementedError, "method not supported" unless self.class.support?(:post)
            raise RuntimeError, "client not configured" unless configured?
            if id
                logger.warn "Object has :id - calling :put instead" if logger
                return put
            end
            raise RuntimeError, "object cannot be saved" unless new?
            params = changes.inject({}) do |hash, property|
                hash[property] = instance_variable_get("@#{property}")
                hash
            end
            require_properties(:post, params)
            validate(:post, params)
            check_conditions(params)
            response = post_request(params)
            if response.is_a?(KayakoClient::HTTPOK)
                if logger
                    logger.debug "Response:"
                    logger.debug response.body
                end
                payload = xml_backend.new(response.body, { :logger => logger })
                clean
                import(payload.to_hash)
                loaded!
                logger.info ":post successful" if logger
                true
            else
                unless response.is_a?(Hash)
                    logger.error "Response: #{response.status} #{response.body}" if logger
                    raise StandardError, "server returned #{response.status}: #{response.body}"
                end
                false
            end
        end

        alias_method :save, :post

        def delete
            raise NotImplementedError, "method not supported" unless self.class.support?(:delete)
            raise RuntimeError, "client not configured" unless configured?
            unless new?
                response = delete_request
                if response.is_a?(KayakoClient::HTTPOK)
                    logger.info ":delete successful for object##{id}" if logger
                else
                    logger.error "Response: #{response.status} #{response.body}" if logger
                    raise StandardError, "server returned #{response.status}: #{response.body}"
                end
            else
                logger.warn "cannot delete new object" if logger
                raise StandardError, "cannot delete new object"
            end
        end

        alias_method :destroy, :delete

        module ClassMethods

            def api_url=(url)
                @@api_url = url
            end

            def api_url
                @@api_url ||= ''
            end

            def api_key=(key)
                @@api_key = key
            end

            def api_key
                @@api_key ||= ''
            end

            def secret_key=(secret)
                @@secret_key = secret
            end

            def secret_key
                @@secret_key ||= ''
            end

            def all(options = {})
                raise NotImplementedError, "method not supported" unless support?(:all)
                unless configured? || (options[:api_url] && options[:api_key] && options[:secret_key])
                    raise RuntimeError, "client not configured"
                end
                response = get_request(options)
                log = options[:logger] || logger
                if response.is_a?(KayakoClient::HTTPOK)
                    objects = []
                    if log
                        log.debug "Response:"
                        log.debug response.body
                    end
                    payload = xml_backend.new(response.body, { :logger => log })
                    payload.each do |element|
                        object = new(payload.to_hash(element).merge(inherited_options(options)))
                        object.loaded!
                        objects << object
                    end
                    log.info ":get(:all) successful (#{objects.size} objects)" if log
                    objects
                else
                    log.error "Response: #{response.status} #{response.body}" if log
                    raise StandardError, "server returned #{response.status}: #{response.body}"
                end
            end

            def get(*args)
                options = args.last.is_a?(Hash) ? args.pop : {}
                id = args[0]
                id = :all unless id || options[:id]
                raise NotImplementedError, "method not supported" unless support?(:get)
                unless configured? || (options[:api_url] && options[:api_key] && options[:secret_key])
                    raise RuntimeError, "client not configured"
                end
                log = options[:logger] || logger
                if id == :all
                    return all(options)
                elsif id && id.to_i > 0
                    id = id.to_i
                elsif options[:id]
                    id = options[:id]
                else
                    if id
                        log.error "invalid :id - #{id}" if log
                        raise ArgumentError, "invalid ID"
                    else
                        log.error "missing :id" if log
                        raise ArgumentError, "missing ID"
                    end
                end
                response = get_request(options.merge(:id => id))
                if response.is_a?(KayakoClient::HTTPOK)
                    if log
                        log.debug "Response:"
                        log.debug response.body
                    end
                    payload = xml_backend.new(response.body, { :logger => log })
                    params = payload.to_hash
                    unless params.nil?
                        object = new(params.merge(inherited_options(options)))
                        object.loaded!
                        log.info ":get(#{id}) successful" if log
                        object
                    else
                        log.info ":get(#{id}) successful (not found)" if log
                        nil
                    end
                else
                    log.error "Response: #{response.status} #{response.body}" if log
                    raise StandardError, "server returned #{response.status}: #{response.body}"
                end
            end

            alias_method :find, :get

            def post(options = {})
                raise NotImplementedError, "method not supported" unless support?(:post)
                object = new(options)
                if object.post
                    object
                else
                    object.has_errors? ? object.errors : nil
                end
            end

            alias_method :create, :post

            def delete(id, options = {})
                raise NotImplementedError, "method not supported" unless support?(:delete)
                unless configured? || (options[:api_url] && options[:api_key] && options[:secret_key])
                    raise RuntimeError, "client not configured"
                end
                response = delete_request(options.merge(:id => id))
                log = options[:logger] || logger
                if response.is_a?(KayakoClient::HTTPOK)
                    log.info ":delete successful for object##{id}" if log
                    true
                else
                    log.error "Response: #{response.status} #{response.body}" if log
                    raise StandardError, "server returned #{response.status}: #{response.body}"
                    false
                end
            end

            alias_method :destroy, :delete

        private

            def configured?
                !api_url.empty? && !api_key.empty? && !secret_key.empty?
            end

        end

    private

        def configured?
            !api_url.empty? && !api_key.empty? && !secret_key.empty?
        end

        def reload!(options = {})
            raise NotImplementedError, "method not supported" unless self.class.support?(:get)
            raise RuntimeError, "client not configured" unless configured?
            raise RuntimeError, "cannot reload modified object" if changed?
            raise RuntimeError, "object not saved yet" unless id && !new?
            response = self.class.get_request(options.merge(:id => id))
            if response.is_a?(KayakoClient::HTTPOK)
                if logger
                    logger.debug "Response:"
                    logger.debug response.body
                end
                payload = xml_backend.new(response.body, { :logger => logger })
                clean
                import(payload.to_hash)
                loaded!
                logger.info ":get(#{id}) successful" if logger
                true
            else
                logger.error "Response: #{response.status} #{response.body}" if logger
                raise StandardError, "server returned #{response.status}: #{response.body}"
                false
            end
        end

    end
end
