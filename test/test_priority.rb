require 'test/unit'
require 'kayako_client'

class TestPriority < Test::Unit::TestCase

    def test_priority_mixins
        assert KayakoClient::TicketPriority.included_modules.include?(KayakoClient::UserVisibilityAPI)

        test = KayakoClient::TicketPriority.new(
            :user_visibility_custom => true,
            :user_group_ids         => [ 1 ]
        )
        assert test.visible_to_user_group?(1)
    end

    def test_priority_methods
        test = KayakoClient::TicketPriority.new

        assert_raise NotImplementedError do
            test.put
        end

        assert_raise NotImplementedError do
            test.post
        end

        assert_raise NotImplementedError do
            test.delete
        end
    end

end
