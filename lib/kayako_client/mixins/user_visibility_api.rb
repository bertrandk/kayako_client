module KayakoClient
    module UserVisibilityAPI

        def visible_to_user_group?(group)
            !user_visibility_custom || (!user_group_ids.nil? && user_group_ids.include?(group.to_i))
        end

    end
end
