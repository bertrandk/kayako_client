require 'kayako_client/mixins/user_visibility_api'

require 'kayako_client/department'

module KayakoClient
    class TicketType < KayakoClient::Tickets
        include KayakoClient::UserVisibilityAPI

        supports :all, :get

        TYPE_TYPES = [ :public, :private ].freeze

        property :id,                     :integer
        property :title,                  :string
        property :display_order,          :integer
        property :department_id,          :integer
        property :display_icon,           :string
        property :type,                   :symbol, :in => TYPE_TYPES
        property :user_visibility_custom, :boolean
        property :user_group_ids,       [ :integer ], :get => :usergroupid, :condition => { :user_visibility_custom => true }

        associate :department,            :department_id, Department
        associate :user_groups,           :user_group_ids, UserGroup

    end
end
