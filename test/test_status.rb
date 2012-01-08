require 'test/unit'
require 'kayako_client'

class TestStatus < Test::Unit::TestCase

    def test_status_methods
        test = KayakoClient::TicketStatus.new

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

    def test_status_constants
        assert KayakoClient::TicketStatus::STATUS_TYPES.include?(:public)
        assert KayakoClient::TicketStatus::STATUS_TYPES.include?(:private)
    end

    def test_status_customs
        test = KayakoClient::TicketStatus.new(
            :staffvisibilitycustom => true,
            :staffgroupid => [ 1, 2 ]
        )

        assert test.respond_to?(:visible_to_staff_group?)
        assert test.visible_to_staff_group?(1)
        assert !test.visible_to_staff_group?(3)
    end

end
