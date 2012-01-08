require 'kayako_client/mixins/user_visibility_api'

require 'kayako_client/user_group'

module KayakoClient
    class Department < KayakoClient::Base
        include KayakoClient::UserVisibilityAPI

        DEPARTMENT_TYPES   = [ :public, :private ].freeze
        DEPARTMENT_MODULES = [ :tickets, :livechat ].freeze

        # NOTE: if :parent_department_id is set :module should have the same value

        property :id,                     :integer, :readonly => true
        property :title,                  :string, :required => [ :put, :post ]
        property :type,                   :symbol, :in => DEPARTMENT_TYPES, :required => :post
        property :module,                 :symbol, :in => DEPARTMENT_MODULES, :required => :post, :new => true
        property :display_order,          :integer
        property :parent_department_id,   :integer
        property :user_visibility_custom, :boolean
        property :user_group_ids,       [ :integer ], :get => :usergroups, :set => :usergroupid, :condition => { :user_visibility_custom => true }

        associate :parent_department,     :parent_department_id, Department
        associate :user_groups,           :user_group_ids,       UserGroup

        def has_parent_department?
            !parent_department_id.nil? && parent_department_id > 0
        end

    end
end
