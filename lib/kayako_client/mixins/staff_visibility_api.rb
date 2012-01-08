module KayakoClient
    module StaffVisibilityAPI

        def visible_to_staff_group?(group)
            !staff_visibility_custom || (!staff_group_ids.nil? && staff_group_ids.include?(group.to_i))
        end

    end
end
