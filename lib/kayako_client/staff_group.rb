module KayakoClient
    class StaffGroup < KayakoClient::Base

        property :id,       :integer, :readonly => true
        property :title,    :string, :required => [ :put, :post ]
        property :is_admin, :boolean, :required => :post

    end
end
