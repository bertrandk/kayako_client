require 'kayako_client/mixins/ticket_api'

require 'kayako_client/staff'
require 'kayako_client/ticket'
require 'kayako_client/user'
require 'kayako_client/user_organization'

module KayakoClient

    class Ticket < KayakoClient::Tickets
    end

    class TicketNote < KayakoClient::Tickets
        include KayakoClient::TicketAPI

        supports :all, :get, :post, :delete

        NOTE_TYPES = [ :ticket, :user, :userorganization, :timetrack ].freeze

        COLOR_YELLOW = 1
        COLOR_PURPLE = 2
        COLOR_BLUE   = 3
        COLOR_GREEN  = 4
        COLOR_RED    = 5

        property :id,                   :integer, :readonly => true
        property :type,                 :symbol,  :readonly => true, :in => NOTE_TYPES
        property :ticket_id,            :integer, :new => true, :required => :post
        property :note_color,           :integer, :new => true, :range => 1..5
        property :creator_staff_id,     :integer, :readonly => true
        property :creator_staff_name,   :string,  :readonly => true
        property :for_staff_id,         :integer, :new => true
        property :creation_date,        :date,    :readonly => true
        property :contents,             :string,  :new => true, :required => :post
        property :user_id,              :integer, :readonly => true # :type = :user
        property :user_organization_id, :integer, :readonly => true # :type = :userorganization
        property :time_worked,          :integer, :readonly => true # :type = :timetrack
        property :time_billable,        :integer, :readonly => true # :type = :timetrack
        property :bill_date,            :date,    :readonly => true # :type = :timetrack
        property :work_date,            :date,    :readonly => true # :type = :timetrack
        property :worker_staff_id,      :integer, :readonly => true # :type = :timetrack
        property :worker_staff_name,    :string,  :readonly => true # :type = :timetrack
        property :staff_id,             :integer, :new => true
        property :full_name,            :string,  :new => true

        associate :ticket,              :ticket_id,            Ticket
        associate :creator_staff,       :creator_staff_id,     Staff
        associate :for_staff,           :for_staff_id,         Staff
        associate :user,                :user_id,              User
        associate :user_organization,   :user_organization_id, UserOrganization
        associate :worker_staff,        :worker_staff_id,      Staff

        # NOTE: :all returns only notes of :ticket type

        def is_ticket_note?
            !type.nil? && type == :ticket
        end

        def is_user_note?
            !type.nil? && type == :user
        end

        def is_user_organization_note?
            !type.nil? && type == :userorganization
        end

        def is_time_track_note?
            !type.nil? && type == :timetrack
        end

        def has_creator_staff?
            !creator_staff_id.nil? && creator_staff_id > 0
        end

        def has_for_staff?
            !for_staff_id.nil? && for_staff_id > 0
        end

        def created_by_user?
            !user_id.nil? && user_id > 0
        end

        alias_method :has_user?, :created_by_user?

        def has_user_organization?
            !user_organization_id.nil? && user_organization_id > 0
        end

        def has_worker_staff?
            !worker_staff_id.nil? && worker_staff_id > 0
        end

    private

        def validate(method, params)
            if method == :post
                unless params[:staff_id] || params[:full_name]
                    raise ArgumentError, ":staff_id or :full_name is required"
                end
            end
        end

    end

end
