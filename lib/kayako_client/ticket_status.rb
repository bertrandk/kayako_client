require 'kayako_client/department'

module KayakoClient
    class TicketStatus < KayakoClient::Tickets
        include KayakoClient::StaffVisibilityAPI

        supports :all, :get

        STATUS_TYPES = [ :public, :private ].freeze

        property :id,                      :integer
        property :title,                   :string
        property :display_order,           :integer
        property :department_id,           :integer
        property :display_icon,            :string
        property :type,                    :symbol, :in => STATUS_TYPES
        property :display_in_main_list,    :boolean
        property :mark_as_resolved,        :boolean
        property :display_count,           :integer
        property :status_color,            :string
        property :status_bg_color,         :string
        property :reset_due_time,          :boolean
        property :trigger_survey,          :boolean
        property :staff_visibility_custom, :boolean
        property :staff_group_ids,       [ :integer ], :get => :staffgroupid, :condition => { :staff_visibility_custom => true }

        associate :department,             :department_id,   Department
        associate :staff_groups,           :staff_group_ids, StaffGroup

    end
end
