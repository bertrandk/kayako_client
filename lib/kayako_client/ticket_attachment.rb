require 'kayako_client/mixins/ticket_api'
require 'kayako_client/mixins/attachment'

require 'kayako_client/ticket'
require 'kayako_client/ticket_post'

module KayakoClient
    class TicketAttachment < KayakoClient::Tickets
        include KayakoClient::TicketAPI
        include KayakoClient::Attachment

        supports :all, :get, :post, :delete

        property :id,             :integer, :readonly => true
        property :ticket_id,      :integer, :required => :post
        property :ticket_post_id, :integer, :required => :post
        property :file_name,      :string, :required => :post
        property :file_size,      :integer, :readonly => true
        property :file_type,      :string, :readonly => true
        property :date_line,      :date, :readonly => true
        property :contents,       :binary, :required => :post, :new => true

        associate :ticket,        :ticket_id,      Ticket
        associate :ticket_post,   :ticket_post_id, TicketPost

        def contents
            if instance_variable_defined?(:@contents)
                instance_variable_get(:@contents)
            elsif !new? && id && ticket_id && id > 0 && ticket_id > 0
                logger.debug "contents are missing - trying to reload" if logger
                if reload!(:e => "#{self.class.path}/#{ticket_id.to_i}/#{id.to_i}") && instance_variable_defined?(:@contents)
                    instance_variable_get(:@contents)
                else
                    instance_variable_set(:@contents, nil)
                end
            else
                nil
            end
        end

    end
end
