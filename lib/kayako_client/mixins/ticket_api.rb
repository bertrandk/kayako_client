module KayakoClient
    module TicketAPI

        def self.included(base)
            base.extend(ClassMethods)
        end

        def delete_request(options = {})
            raise RuntimeError, "undefined ticket ID" unless ticket_id
            raise RuntimeError, "undefined ID" unless id
            super(options.merge(:e => "#{self.class.path}/#{ticket_id}/#{id}"))
        end

        module ClassMethods

            def all(ticket, options = {})
                unless ticket.to_i > 0
                    logger.error "invalid :ticket_id - #{ticket}" if logger
                    raise ArgumentError, "invalid ticket ID"
                end
                super(options.merge(:e => "#{path}/ListAll/#{ticket.to_i}"))
            end

            def get(ticket, id, options = {})
                unless ticket.to_i > 0
                    logger.error "invalid :ticket_id - #{ticket}" if logger
                    raise ArgumentError, "invalid ticket ID"
                end
                if id == :all
                    all(ticket, options)
                else
                    unless id.to_i > 0
                        logger.error "invalid :id - #{id}" if logger
                        raise ArgumentError, "invalid ID"
                    end
                    super(id, options.merge(:e => "#{path}/#{ticket.to_i}/#{id.to_i}"))
                end
            end

            def delete(ticket, id, options = {})
                unless ticket.to_i > 0
                    logger.error "invalid :ticket_id - #{ticket}" if logger
                    raise ArgumentError, "invalid ticket ID"
                end
                unless id.to_i > 0
                    logger.error "invalid :id - #{id}" if logger
                    raise ArgumentError, "invalid ID"
                end
                super(id, options.merge(:e => "#{path}/#{ticket.to_i}/#{id.to_i}"))
            end

        end

    end
end
