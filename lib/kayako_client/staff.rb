require 'kayako_client/staff_group'

module KayakoClient
    class Staff < KayakoClient::Base

        property :id,             :integer, :readonly => true
        property :staff_group_id, :integer, :required => [ :put, :post ]
        property :user_name,      :string, :required => [ :put, :post ]
        property :password,       :string, :required => :post
        property :first_name,     :string, :required => [ :put, :post ]
        property :last_name,      :string, :required => [ :put, :post ]
        property :full_name,      :string, :readonly => true
        property :email,          :string, :required => [ :put, :post ]
        property :designation,    :string
        property :signature,      :string
        property :greeting,       :string
        property :mobile_number,  :string
        property :is_enabled,     :boolean
        property :time_zone,      :string
        property :enable_dst,     :boolean

        associate :staff_group,   :staff_group_id, StaffGroup

    end
end
