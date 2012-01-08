module KayakoClient
    module PostClient

        def attachments(options = {})
            values = []
            if ticket_id && id
                items = KayakoClient::TicketAttachment.all(ticket_id, options.merge(inherited_options))
                items.each do |item|
                    values << item if item.ticket_post_id == id
                end
            end
            values
        end

        def get_attachment(attachment, options = {})
            KayakoClient::TicketAttachment.get(ticket_id, attachment, options.merge(inherited_options)) if ticket_id
        end

        alias_method :find_attachment, :get_attachment

        def post_attachment(options = {})
            if ticket_id && id
                if logger
                    logger.warn "overwriting :ticket_id"      if options[:ticket_id] && options[:ticket_id].to_i != ticket_id
                    logger.warn "overwriting :ticket_post_id" if options[:ticket_post_id] && options[:ticket_post_id].to_i != id
                end
                options[:ticket_id] = ticket_id
                options[:ticket_post_id] = id
                KayakoClient::TicketAttachment.post(options.merge(inherited_options))
            end
        end

        alias_method :create_attachment, :post_attachment

        def delete_attachment(attachment, options = {})
            KayakoClient::TicketAttachment.delete(ticket_id, attachment, options.merge(inherited_options)) if ticket_id
        end

        alias_method :destroy_attachment, :delete_attachment

    end
end
