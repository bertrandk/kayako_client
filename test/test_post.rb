require 'test/unit'
require 'kayako_client'

class TestPost < Test::Unit::TestCase

    def test_post_methods
        test = KayakoClient::TicketPost.new
        assert_raise NotImplementedError do
            test.put
        end
    end

    def test_post_ticket_api
        assert KayakoClient::TicketPost.included_modules.include?(KayakoClient::TicketAPI)
    end

    def test_post_constants
        assert_equal KayakoClient::TicketPost::CREATOR_STAFF, 1
        assert_equal KayakoClient::TicketPost::CREATOR_USER,  2
    end

    def test_post_validate
        test = KayakoClient::TicketPost.new(
            :ticket_id => 1,
            :subject   => 'Test',
            :contents  => 'Test.'
        )

        assert_raise ArgumentError do
            test.post
        end
    end

    def test_post_boolean
        test = KayakoClient::TicketPost.new(
            :has_attachments   => 1,
            :is_third_party    => 0,
            :is_html           => 1,
            :is_emailed        => 0,
            :is_survey_comment => 1
        )

        assert test.has_attachments?
        assert !test.is_third_party?
        assert test.is_html?
        assert !test.is_emailed?
        assert test.is_survey_comment?
    end

end
