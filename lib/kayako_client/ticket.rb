require 'kayako_client/department'

require 'kayako_client/staff'

require 'kayako_client/ticket_note'
require 'kayako_client/ticket_post'
require 'kayako_client/ticket_status'
require 'kayako_client/ticket_priority'
require 'kayako_client/ticket_type'

require 'kayako_client/user'
require 'kayako_client/user_organization'

module KayakoClient

    class TicketWorkflow < KayakoClient::Tickets
        embedded

        property :id,    :integer
        property :title, :string

    end

    class TicketWatcher < KayakoClient::Tickets
        embedded

        property :staff_id, :integer
        property :name,     :string

        associate :staff,   :staff_id, Staff
    end

    class Ticket < KayakoClient::Tickets
        include KayakoClient::TicketClient

        # NOTE: department is required to be of :tickets type

        FLAG_NONE   = 0
        FLAG_PURPLE = 1
        FLAG_ORANGE = 2
        FLAG_GREEN  = 3
        FLAG_YELLOW = 4
        FLAG_RED    = 5
        FLAG_BLUE   = 6

        SEARCH_TICKET_ID         = 0x0001
        SEARCH_CONTENTS          = 0x0002
        SEARCH_AUTHOR            = 0x0004
        SEARCH_EMAIL             = 0x0008
        SEARCH_CREATOR_EMAIL     = 0x0010
        SEARCH_FULL_NAME         = 0x0020
        SEARCH_NOTES             = 0x0040
        SEARCH_USER_GROUP        = 0x0080
        SEARCH_USER_ORGANIZATION = 0x0100
        SEARCH_USER              = 0x0200
        SEARCH_TAGS              = 0x0400

        TICKET_TYPES = [ :default, :phone ].freeze

        property :id,                   :integer, :readonly => true
        property :flag_type,            :integer, :readonly => true, :range => 0..6
        property :display_id,           :string, :readonly => true
        property :department_id,        :integer, :required => :post
        property :status_id,            :integer, :required => :post, :set => :ticketstatusid
        property :priority_id,          :integer, :required => :post, :set => :ticketpriorityid
        property :type_id,              :integer, :required => :post, :set => :tickettypeid
        property :user_id,              :integer
        property :user_organization,    :string, :readonly => true
        property :user_organization_id, :integer, :readonly => true
        property :owner_staff_id,       :integer
        property :owner_staff_name,     :string, :readonly => true
        property :full_name,            :string, :required => :post
        property :email,                :string, :required => :post
        property :last_replier,         :string, :readonly => true
        property :subject,              :string, :required => :post
        property :creation_time,        :date, :readonly => true
        property :last_activity,        :date, :readonly => true
        property :last_staff_reply,     :date, :readonly => true
        property :last_user_reply,      :date, :readonly => true
        property :sla_plan_id,          :integer, :readonly => true
        property :next_reply_due,       :date, :readonly => true
        property :resolution_due,       :date, :readonly => true
        property :replies,              :integer, :readonly => true
        property :ip_address,           :string, :readonly => true
        property :creator,              :integer, :readonly => true
        property :creation_mode,        :integer, :readonly => true
        property :creation_type,        :integer, :readonly => true
        property :is_escalated,         :boolean, :readonly => true
        property :escalation_rule_id,   :integer, :readonly => true
        property :tags,                 :string, :readonly => true
        property :contents,             :string, :new => true, :required => :post
        property :auto_user_id,         :boolean, :new => true
        property :staff_id,             :integer, :new => true
        property :type,                 :symbol, :new => true, :in => TICKET_TYPES

        property :work_flow,            :object,   :class => TicketWorkflow
        property :watcher,            [ :object ], :class => TicketWatcher
        property :note,               [ :object ], :class => TicketNote
        property :posts,              [ :object ], :class => TicketPost

        associate :department,          :department_id,        Department
        associate :ticket_status,       :status_id,            TicketStatus
        associate :ticket_priority,     :priority_id,          TicketPriority
        associate :ticket_type,         :type_id,              TicketType
        associate :user,                :user_id,              User
        associate :organization,        :user_organization_id, UserOrganization
        associate :owner_staff,         :owner_staff_id,       Staff

        def posts
            if instance_variable_defined?(:@posts)
                instance_variable_get(:@posts)
            elsif !new? && id && id > 0
                logger.debug "posts are missing - trying to load" if logger
                post = KayakoClient::TicketPost.all(id, inherited_options)
                if post && !post.empty?
                    instance_variable_set(:@posts, post)
                else
                    instance_variable_set(:@posts, nil)
                end
            else
                nil
            end
        end

        def created_by_user?
            !user_id.nil? && user_id > 0
        end

        alias_method :has_user?, :created_by_user?

        def has_user_organization?
            !user_organization_id.nil? && user_organization_id > 0
        end

        def has_owner_staff?
            !owner_staff_id.nil? && owner_staff_id > 0
        end

        def self.all(*args)
            options = args.last.is_a?(Hash) ? args.pop : {}

            components = []
            args.each_index do |index|
                break if index > 3
                if args[index]
                    components[index] ||= []
                    components[index] << args[index]
                end
            end

            options.keys.each do |option|
                case option.to_s.gsub(%r{_}, '')
                when 'departmentid', 'department'
                    index = 0
                when 'ticketstatusid', 'ticketstatus'
                    index = 1
                when 'ownerstaffid', 'ownerstaff'
                    index = 2
                when 'userid', 'user'
                    index = 3
                else
                    next
                end
                components[index] ||= []
                components[index] << options.delete(option)
            end

            raise ArgumentError, "missing :department_id" unless components[0]

            e = path + '/ListAll' + components.inject('') do |uri, item|
                uri << '/' + (item.nil? ? '-1' : item.flatten.uniq.join(','))
            end

            super(options.merge(:e => e))
        end

        def self.get(id = :all, options = {})
            if id == :all
                all(options.delete(:id), options)
            else
                super(options.merge(:id => id))
            end
        end

        def self.search(query, flags = SEARCH_CONTENTS, options = {})
            unless configured? || (options[:api_url] && options[:api_key] && options[:secret_key])
                raise RuntimeError, "client not configured"
            end

            params = {
                :e     => '/Tickets/TicketSearch',
                :query => query
            }

            params[:ticketid]         = 1 unless flags & SEARCH_TICKET_ID         == 0x0000
            params[:contents]         = 1 unless flags & SEARCH_CONTENTS          == 0x0000
            params[:author]           = 1 unless flags & SEARCH_AUTHOR            == 0x0000
            params[:email]            = 1 unless flags & SEARCH_EMAIL             == 0x0000
            params[:creatoremail]     = 1 unless flags & SEARCH_CREATOR_EMAIL     == 0x0000
            params[:fullname]         = 1 unless flags & SEARCH_FULL_NAME         == 0x0000
            params[:notes]            = 1 unless flags & SEARCH_NOTES             == 0x0000
            params[:usergroup]        = 1 unless flags & SEARCH_USER_GROUP        == 0x0000
            params[:userorganization] = 1 unless flags & SEARCH_USER_ORGANIZATION == 0x0000
            params[:user]             = 1 unless flags & SEARCH_USER              == 0x0000
            params[:tags]             = 1 unless flags & SEARCH_TAGS              == 0x0000

            response = post_request(options.merge(params))
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
                log.info ":post(:search, '#{params[:query]}', #{sprintf("0x%04X", flags)}) successful (#{objects.size} objects)" if log
                objects
            else
                log.error "Response: #{response.status} #{response.body}" if log
                raise StandardError, "server returned #{response.status}: #{response.body}"
            end
        end

    private

        def validate(method, params)
            if method == :post
                unless params[:auto_user_id] || params[:user_id] || params[:staff_id]
                    raise ArgumentError, ":auto_user_id, :user_id or :staff_id is required"
                end
            end
        end

    end

end
