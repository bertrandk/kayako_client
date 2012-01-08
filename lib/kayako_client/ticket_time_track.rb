require 'kayako_client/mixins/ticket_api'

module KayakoClient
    class TicketTimeTrack < KayakoClient::Tickets
        include KayakoClient::TicketAPI

        supports :all, :get, :post, :delete

        property :id,                 :integer, :readonly => true
        property :ticket_id,          :integer, :required => :post
        property :time_worked,        :integer, :required => :post, :set => :timespent
        property :time_billable,      :integer, :required => :post
        property :bill_date,          :date,    :required => :post, :set => :billtimeline
        property :work_date,          :date,    :required => :post, :set => :worktimeline
        property :worker_staff_id,    :integer
        property :worker_staff_name,  :string,  :readonly => true
        property :creator_staff_id,   :integer, :required => :post, :set => :staffid
        property :creator_staff_name, :string,  :readonly => true
        property :note_color,         :integer, :range => 1..5
        property :contents,           :string,  :required => :post

        associate :ticket,            :ticket_id,        Ticket
        associate :worker_staff,      :worker_staff_id,  Staff
        associate :creator_staff,     :creator_staff_id, Staff

    end
end
