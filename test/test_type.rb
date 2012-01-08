require 'test/unit'
require 'kayako_client'

class TestType < Test::Unit::TestCase

    def test_type_mixin
        assert KayakoClient::TicketType.included_modules.include?(KayakoClient::UserVisibilityAPI)

        test = KayakoClient::TicketType.new
        assert test.respond_to?(:visible_to_user_group?)
        assert test.respond_to?(:user_visibility_custom)
        assert test.respond_to?(:user_group_ids)
    end

    def test_type_methods
        test = KayakoClient::TicketType.new

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

    def test_type_constants
        assert KayakoClient::TicketType::TYPE_TYPES.include?(:public)
        assert KayakoClient::TicketType::TYPE_TYPES.include?(:private)
    end

    def test_type_visibility
        test = KayakoClient::TicketType.new(
            :uservisibilitycustom => true,
            :usergroupid => [ 1, 2 ]
        )

        assert test.visible_to_user_group?(1)
        assert !test.visible_to_user_group?(3)
    end

    def test_type_associates
        test = KayakoClient::TicketType.new
        test.respond_to?(:department)
    end

end
