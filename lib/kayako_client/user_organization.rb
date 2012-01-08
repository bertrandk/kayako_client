module KayakoClient
    class UserOrganization < KayakoClient::Base

        USER_ORGANIZATION_TYPES = [ :restricted, :shared ].freeze

        property :id,                :integer, :readonly => true
        property :name,              :string, :required => [ :put, :post ]
        property :organization_type, :symbol, :required => :post, :in => USER_ORGANIZATION_TYPES
        property :address,           :string
        property :city,              :string
        property :state,             :string
        property :postal_code,       :integer
        property :country,           :string
        property :phone,             :string
        property :fax,               :string
        property :website,           :string
        property :date_line,         :date, :readonly => true
        property :last_update,       :date, :readonly => true
        property :sla_plan_id,       :integer
        property :sla_plan_expiry,   :date

    end
end
