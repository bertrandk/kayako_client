require 'kayako_client/mixins/ticket_api'

require 'kayako_client/staff'
require 'kayako_client/user'

module KayakoClient
    class TicketPost < KayakoClient::Tickets
        include KayakoClient::TicketAPI
        include KayakoClient::PostClient

        supports :all, :get, :post, :delete

        CREATOR_STAFF = 1
        CREATOR_USER  = 2

        property :id,                :integer, :readonly => true
        property :date_line,         :date,    :readonly => true
        property :user_id,           :integer, :new => true
        property :full_name,         :string,  :readonly => true
        property :email,             :string,  :readonly => true
        property :email_to,          :string,  :readonly => true
        property :ip_address,        :string,  :readonly => true
        property :has_attachments,   :boolean, :readonly => true
        property :creator,           :integer, :readonly => true, :range => 1..2
        property :is_third_party,    :boolean, :readonly => true
        property :is_html,           :boolean, :readonly => true
        property :is_emailed,        :boolean, :readonly => true
        property :staff_id,          :integer, :new => true
        property :is_survey_comment, :boolean, :readonly => true
        property :contents,          :string,  :new => true, :required => :post
        property :ticket_id,         :integer, :new => true, :required => :post
        property :subject,           :string,  :new => true, :required => :post
        property :ticket_post_id,    :integer, :readonly => true

        associate :user,             :user_id,  User
        associate :staff,            :staff_id, Staff

        def created_by_staff?
            !creator.nil? && creator == CREATOR_STAFF
        end

        alias_method :has_staff?, :created_by_staff?

        def created_by_user?
            !creator.nil? && creator == CREATOR_USER
        end

        alias_method :has_user?, :created_by_user?

    private

        def validate(method, params)
            if method == :post
                unless params[:user_id] || params[:staff_id]
                    raise ArgumentError, ":user_id or :staff_id is required"
                end
            end
        end

    end
end
