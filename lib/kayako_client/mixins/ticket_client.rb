module KayakoClient
    module TicketClient

        def self.included(base)
            base.extend(ClassMethods)
        end


        def attachments(options = {})
            KayakoClient::TicketAttachment.all(id, options.merge(inherited_options)) if id
        end

        def get_attachment(attachment, options = {})
            KayakoClient::TicketAttachment.get(id, attachment, options.merge(inherited_options)) if id
        end

        alias_method :find_attachment, :get_attachment

        def post_attachment(options = {})
            if id
                if logger && options[:ticket_id] && options[:ticket_id].to_i != id
                    logger.warn "overwriting :ticket_id"
                end
                options[:ticket_id] = id
                KayakoClient::TicketAttachment.post(options.merge(inherited_options))
            end
        end

        alias_method :create_attachment, :post_attachment

        def delete_attachment(attachment, options = {})
            KayakoClient::TicketAttachment.delete(id, attachment, options.merge(inherited_options)) if id
        end

        alias_method :destroy_attachment, :delete_attachment


        def custom_fields(options = {})
            KayakoClient::TicketCustomField.get(id, options.merge(inherited_options)) if id
        end


        def notes(options = {})
            KayakoClient::TicketNote.all(id, options.merge(inherited_options)) if id
        end

        def get_note(note, options = {})
            KayakoClient::TicketNote.get(id, note, options.merge(inherited_options)) if id
        end

        alias_method :find_note, :get_note

        def post_note(options = {})
            if id
                if logger && options[:ticket_id] && options[:ticket_id].to_i != id
                    logger.warn "overwriting :ticket_id"
                end
                options[:ticket_id] = id
                KayakoClient::TicketNote.post(options.merge(inherited_options))
            end
        end

        alias_method :create_note, :post_note

        def delete_note(note, options = {})
            KayakoClient::TicketNote.delete(id, note, options.merge(inherited_options)) if id
        end

        alias_method :destroy_note, :delete_note


        def get_post(post, options = {})
            KayakoClient::TicketPost.get(id, post, options.merge(inherited_options)) if id
        end

        alias_method :find_post, :get_post

        def post_post(options = {})
            if id
                if logger && options[:ticket_id] && options[:ticket_id].to_i != id
                    logger.warn "overwriting :ticket_id"
                end
                options[:ticket_id] = id
                KayakoClient::TicketPost.post(options.merge(inherited_options))
            end
        end

        alias_method :create_post, :post_post

        def delete_post(post, options = {})
            KayakoClient::TicketPost.delete(id, post, options.merge(inherited_options)) if id
        end

        alias_method :destroy_post, :delete_post


        def time_tracks(options = {})
            KayakoClient::TicketTimeTrack.all(id, options.merge(inherited_options)) if id
        end

        def get_time_track(track, options = {})
            KayakoClient::TicketTimeTrack.get(id, track, options.merge(inherited_options)) if id
        end

        alias_method :find_time_track, :get_time_track

        def post_time_track(options = {})
            if id
                if logger && options[:ticket_id] && options[:ticket_id].to_i != id
                    logger.warn "overwriting :ticket_id"
                end
                options[:ticket_id] = id
                KayakoClient::TicketTimeTrack.post(options.merge(inherited_options))
            end
        end

        alias_method :create_time_track, :post_time_track

        def delete_time_track(track, options = {})
            KayakoClient::TicketTimeTrack.delete(id, track, options.merge(inherited_options)) if id
        end

        alias_method :destroy_time_track, :delete_time_track


        module ClassMethods

            def count(options = {})
                KayakoClient::TicketCount.get(options.merge(inherited_options(options)))
            end

        end

    end
end
