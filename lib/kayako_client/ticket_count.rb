require 'kayako_client/ticket_status'
require 'kayako_client/ticket_type'
require 'kayako_client/staff'
require 'kayako_client/department'

module KayakoClient

    class TicketCountStatus < KayakoClient::Tickets
        embedded

        property :id,             :integer
        property :last_activity,  :date
        property :total_items,    :integer

        associate :ticket_status, :id, TicketStatus

    end

    class TicketCountType < KayakoClient::Tickets
        embedded

        property :id,                     :integer
        property :last_activity,          :date
        property :total_items,            :integer
        property :total_unresolved_items, :integer

        associate :ticket_type,           :id, TicketType

        def has_ticket_type?
            !id.nil? && id > 0
        end

    end

    class TicketCountOwner < KayakoClient::Tickets
        embedded

        property :id,                     :integer
        property :last_activity,          :date
        property :total_items,            :integer
        property :total_unresolved_items, :integer

        associate :owner_staff,           :id, Staff

        def has_owner_staff?
            !id.nil? && id > 0
        end

    end

    class TicketCountDepartment < KayakoClient::Tickets
        embedded

        property :id,                     :integer
        property :total_items,            :integer
        property :last_activity,          :date
        property :total_unresolved_items, :integer
        property :statuses,             [ :object ], :class => TicketCountStatus, :get => :ticketstatus
        property :types,                [ :object ], :class => TicketCountType, :get => :tickettype
        property :owners,               [ :object ], :class => TicketCountOwner, :get => :ownerstaff

        associate :department,            :id, Department

    end

    class TicketCountUnassigned < KayakoClient::Tickets
        embedded

        property :id,                     :integer
        property :last_activity,          :date
        property :total_items,            :integer
        property :total_unresolved_items, :integer

        # NOTE: :id is not a department id
        #associate :department, :id, Department

    end

    class TicketCount < KayakoClient::Tickets
        supports :get

        property :departments, [ :object ], :class => TicketCountDepartment
        property :statuses,    [ :object ], :class => TicketCountStatus
        property :owners,      [ :object ], :class => TicketCountOwner
        property :unassigned,  [ :object ], :class => TicketCountUnassigned

        def initialize(*args)
            options = args.last.is_a?(Hash) ? args.last : {}
            super(*args)
            if !caller[1].match(%r{/ticket_count\.rb:[0-9]+:in `[^']+'}) &&
                !options[:departments] && !options[:statuses] && !options[:owners] && !options[:unassigned]
                raise RuntimeError, "client not configured" unless configured?
                response = self.class.get_request(options.merge(inherited_options))
                if response.is_a?(KayakoClient::HTTPOK)
                    if logger
                        logger.debug "Response:"
                        logger.debug response.body
                    end
                    payload = xml_backend.new(response.body, { :logger => logger })
                    clean
                    import(payload.to_hash)
                    loaded!
                    logger.info ":get) successful" if logger
                else
                    logger.error "Response: #{response.status} #{response.body}" if logger
                    raise StandardError, "server returned #{response.status}: #{response.body}"
                end
            end
        end

        def self.get(options = {})
            unless configured? || (options[:api_url] && options[:api_key] && options[:secret_key])
                raise RuntimeError, "client not configured"
            end
            log = options[:logger] || logger
            response = get_request(options)
            if response.is_a?(KayakoClient::HTTPOK)
                if log
                    log.debug "Response:"
                    log.debug response.body
                end
                payload = xml_backend.new(response.body, { :logger => log })
                object = new(payload.to_hash.merge(inherited_options(options)))
                object.loaded!
                log.info ":get successful" if log
                object
            else
                log.error "Response: #{response.status} #{response.body}" if log
                raise StandardError, "server returned #{response.status}: #{response.body}"
            end
        end

    end

end
