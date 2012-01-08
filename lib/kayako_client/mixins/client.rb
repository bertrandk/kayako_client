module KayakoClient
    module Client

        def departments(options = {})
            KayakoClient::Department.all(options.merge(inherited_options))
        end

        def get_department(id = :all, options = {})
            KayakoClient::Department.get(id, options.merge(inherited_options))
        end

        alias_method :find_department, :get_department

        def post_department(options = {})
            KayakoClient::Department.post(options.merge(inherited_options))
        end

        alias_method :create_department, :post_department

        def delete_department(id, options = {})
            KayakoClient::Department.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_department, :delete_department


        def staff(options = {})
            KayakoClient::Staff.all(options.merge(inherited_options))
        end

        alias_method :staff_users, :staff

        def get_staff(id = :all, options = {})
            KayakoClient::Staff.get(id, options.merge(inherited_options))
        end

        alias_method :find_staff, :get_staff

        def post_staff(options = {})
            KayakoClient::Staff.post(options.merge(inherited_options))
        end

        alias_method :create_staff, :post_staff

        def delete_staff(id, options = {})
            KayakoClient::Staff.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_staff, :delete_staff


        def staff_groups(options = {})
            KayakoClient::StaffGroup.all(options.merge(inherited_options))
        end

        def get_staff_group(id = :all, options = {})
            KayakoClient::StaffGroup.get(id, options.merge(inherited_options))
        end

        alias_method :find_staff_group, :get_staff_group

        def post_staff_group(options = {})
            KayakoClient::StaffGroup.post(options.merge(inherited_options))
        end

        alias_method :create_staff_group, :post_staff_group

        def delete_staff_group(id, options = {})
            KayakoClient::StaffGroup.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_staff_group, :delete_staff_group


        def tickets(*args)
            options = args.last.is_a?(Hash) ? args.pop : {}
            args << options.merge(inherited_options)
            KayakoClient::Ticket.all(*args)
        end

        def get_ticket(id = :all, options = {})
            KayakoClient::Ticket.get(id, options.merge(inherited_options))
        end

        alias_method :find_ticket, :get_ticket

        def ticket_search(query, flags = KayakoClient::Ticket::SEARCH_CONTENTS, options = {})
            KayakoClient::Ticket.search(query, flags, options.merge(inherited_options))
        end

        def post_ticket(options = {})
            KayakoClient::Ticket.post(options.merge(inherited_options))
        end

        alias_method :create_ticket, :post_ticket

        def delete_ticket(id, options = {})
            KayakoClient::Ticket.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_ticket, :delete_ticket


        def ticket_attachments(ticket, options = {})
            KayakoClient::TicketAttachment.all(ticket, options.merge(inherited_options))
        end

        def get_ticket_attachment(ticket, id, options = {})
            KayakoClient::TicketAttachment.get(ticket, id, options.merge(inherited_options))
        end

        alias_method :find_ticket_attachment, :get_ticket_attachment

        def post_ticket_attachment(options = {})
            KayakoClient::TicketAttachment.post(options.merge(inherited_options))
        end

        alias_method :create_ticket_attachment, :post_ticket_attachment

        def delete_ticket_attachment(ticket, id, options = {})
            KayakoClient::TicketAttachment.delete(ticket, id, options.merge(inherited_options))
        end

        alias_method :destroy_ticket_attachment, :delete_ticket_attachment


        def ticket_count(options = {})
            KayakoClient::TicketCount.get(options.merge(inherited_options))
        end


        def ticket_custom_fields(ticket, options = {})
            KayakoClient::TicketCustomField.get(ticket, options.merge(inherited_options))
        end


        def ticket_notes(ticket, options = {})
            KayakoClient::TicketNote.all(ticket, options.merge(inherited_options))
        end

        def get_ticket_note(ticket, id, options = {})
            KayakoClient::TicketNote.get(ticket, id, options.merge(inherited_options))
        end

        alias_method :find_ticket_note, :get_ticket_note

        def post_ticket_note(options = {})
            KayakoClient::TicketNote.post(options.merge(inherited_options))
        end

        alias_method :create_ticket_note, :post_ticket_note

        def delete_ticket_note(ticket, id, options = {})
            KayakoClient::TicketNote.delete(ticket, id, options.merge(inherited_options))
        end

        alias_method :destroy_ticket_note, :delete_ticket_note


        def ticket_posts(ticket, options = {})
            KayakoClient::TicketPost.all(ticket, options.merge(inherited_options))
        end

        def get_ticket_post(ticket, id, options = {})
            KayakoClient::TicketPost.get(ticket, id, options.merge(inherited_options))
        end

        alias_method :find_ticket_post, :get_ticket_post

        def post_ticket_post(options = {})
            KayakoClient::TicketPost.post(options.merge(inherited_options))
        end

        alias_method :create_ticket_post, :post_ticket_post

        def delete_ticket_post(ticket, id, options = {})
            KayakoClient::TicketPost.delete(ticket, id, options.merge(inherited_options))
        end

        alias_method :destroy_ticket_post, :delete_ticket_post


        def ticket_priorities(options = {})
            KayakoClient::TicketPriority.all(options.merge(inherited_options))
        end

        def get_ticket_priority(id = :all, options = {})
            KayakoClient::TicketPriority.get(id, options.merge(inherited_options))
        end

        alias_method :find_ticket_priority, :get_ticket_priority


        def ticket_statuses(options = {})
            KayakoClient::TicketStatus.all(options.merge(inherited_options))
        end

        def get_ticket_status(id = :all, options = {})
            KayakoClient::TicketStatus.get(id, options.merge(inherited_options))
        end

        alias_method :find_ticket_status, :get_ticket_status


        def ticket_time_tracks(ticket, options = {})
            KayakoClient::TicketTimeTrack.all(ticket, options.merge(inherited_options))
        end

        def get_ticket_time_track(ticket, id, options = {})
            KayakoClient::TicketTimeTrack.get(ticket, id, options.merge(inherited_options))
        end

        alias_method :find_ticket_time_track, :get_ticket_time_track

        def post_ticket_time_track(options = {})
            KayakoClient::TicketTimeTrack.post(options.merge(inherited_options))
        end

        alias_method :create_ticket_time_track, :post_ticket_time_track

        def delete_ticket_time_track(ticket, id, options = {})
            KayakoClient::TicketTimeTrack.delete(ticket, id, options.merge(inherited_options))
        end

        alias_method :destroy_ticket_time_track, :delete_ticket_time_track


        def ticket_types(options = {})
            KayakoClient::TicketType.all(options.merge(inherited_options))
        end

        def get_ticket_type(id = :all, options = {})
            KayakoClient::TicketType.get(id, options.merge(inherited_options))
        end

        alias_method :find_ticket_type, :get_ticket_type


        def users(marker = nil, limit = nil, options = {})
            KayakoClient::User.all(marker, limit, options.merge(inherited_options))
        end

        def get_user(id = :all, options = {})
            KayakoClient::User.get(id, options.merge(inherited_options))
        end

        alias_method :find_user, :get_user

        def post_user(options = {})
            KayakoClient::User.post(options.merge(inherited_options))
        end

        alias_method :create_user, :post_user

        def delete_user(id, options = {})
            KayakoClient::User.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_user, :delete_user


        def user_groups(options = {})
            KayakoClient::UserGroup.all(options.merge(inherited_options))
        end

        def get_user_group(id = :all, options = {})
            KayakoClient::UserGroup.get(id, options.merge(inherited_options))
        end

        alias_method :find_user_group, :get_user_group

        def post_user_group(options = {})
            KayakoClient::UserGroup.post(options.merge(inherited_options))
        end

        alias_method :create_user_group, :post_user_group

        def delete_user_group(id, options = {})
            KayakoClient::UserGroup.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_user_group, :delete_user_group


        def user_organizations(options = {})
            KayakoClient::UserOrganization.all(options.merge(inherited_options))
        end

        def get_user_organization(id = :all, options = {})
            KayakoClient::UserOrganization.get(id, options.merge(inherited_options))
        end

        alias_method :find_user_organization, :get_user_organization

        def post_user_organization(options = {})
            KayakoClient::UserOrganization.post(options.merge(inherited_options))
        end

        alias_method :create_user_organization, :post_user_organization

        def delete_user_organization(id, options = {})
            KayakoClient::UserOrganization.delete(id, options.merge(inherited_options))
        end

        alias_method :destroy_user_organization, :delete_user_organization

    end
end
