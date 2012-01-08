require 'base64'
require 'time'

module KayakoClient

    class TicketCustomFieldValue < KayakoClient::Tickets
        embedded

        property :id,        :integer
        property :type,      :integer, :range => 1..11
        property :title,     :string
        property :file_name, :string
        property :contents,  :string

        def initialize(*args)
            super(*args)
            if defined?(@type)
                if @type == KayakoClient::TicketCustomField::TYPE_FILE
                    self.class.send(:include, KayakoClient::Attachment)
                    if defined?(@contents)
                        logger.debug "decoding base64 :contents" if logger
                        @contents = Base64.decode64(@contents)
                        @contents = Base64.decode64(@contents)
                    end
                elsif @type == KayakoClient::TicketCustomField::TYPE_DATE
                    @contents = Time.parse(@contents) if defined?(@contents)
                end
            end
        end

    end

    class TicketCustomFieldGroup < KayakoClient::Tickets
        embedded

        property :id,       :integer
        property :title,    :string
        property :fields, [ :object ], :class => TicketCustomFieldValue, :get => :field

    end

    class TicketCustomField < KayakoClient::Tickets
        supports :get

        TYPE_TEXT          = 1
        TYPE_TEXT_AREA     = 2
        TYPE_PASSWORD      = 3
        TYPE_CHECKBOX      = 4
        TYPE_RADIO         = 5
        TYPE_SELECT        = 6
        TYPE_MULTI_SELECT  = 7
        TYPE_CUSTOM        = 8
        TYPE_LINKED_SELECT = 9
        TYPE_DATE          = 10
        TYPE_FILE          = 11

        property :groups, [ :object ], :class => TicketCustomFieldGroup, :get => :group

        # NOTE: when a new field is added returns (for old tickets):
        # [Notice]: Undefined offset: 11 (api/class.Controller_TicketCustomField.php:279)

        def empty?
            !(groups && groups.size > 0)
        end

        def custom_field(name)
            if defined?(@groups) && @groups.size > 0
                if name.is_a?(Numeric)
                    if name.to_i > 0
                        @groups.each do |group|
                            next unless group.fields && !group.fields.empty?
                            group.fields.each do |field|
                                if field.id == name.to_i
                                    return field.contents
                                end
                            end
                        end
                    end
                elsif name.is_a?(String)
                    @groups.each do |group|
                        next unless group.fields && !group.fields.empty?
                        group.fields.each do |field|
                            if field.title == name
                                return field.contents
                            end
                        end
                    end
                end
            end
            nil
        end

        def [](name)
            value = custom_field(name) unless name.is_a?(Symbol)
            value || super
        end

        def each(&block)
            if defined?(@groups) && @groups.size > 0
                @custom_fields ||= @groups.inject([]) do |array, group|
                    array.concat(group.fields) if group.fields && group.fields.size > 0
                    array
                end
                @custom_fields.each(&block) unless @custom_fields.empty?
            end
        end

    end

end
