require 'test/unit'
require 'kayako_client'

class TestNote < Test::Unit::TestCase

    def test_note_methods
        test = KayakoClient::TicketNote.new
        assert_raise NotImplementedError do
            test.put
        end
    end

    def test_note_ticket_api
        assert KayakoClient::TicketNote.included_modules.include?(KayakoClient::TicketAPI)
    end

    def test_note_constants
        assert KayakoClient::TicketNote::NOTE_TYPES.include?(:ticket)
        assert KayakoClient::TicketNote::NOTE_TYPES.include?(:user)
        assert KayakoClient::TicketNote::NOTE_TYPES.include?(:userorganization)
        assert KayakoClient::TicketNote::NOTE_TYPES.include?(:timetrack)

        assert_equal KayakoClient::TicketNote::COLOR_YELLOW, 1
        assert_equal KayakoClient::TicketNote::COLOR_PURPLE, 2
        assert_equal KayakoClient::TicketNote::COLOR_BLUE,   3
        assert_equal KayakoClient::TicketNote::COLOR_GREEN,  4
        assert_equal KayakoClient::TicketNote::COLOR_RED,    5
    end

    def test_note_validate
        test = KayakoClient::TicketNote.new(
            :ticket_id => 1,
            :contents  => 'Test'
        )
        assert_raise ArgumentError do
            test.post
        end
    end

    def test_note_associates
        test = KayakoClient::TicketNote.new

        assert test.respond_to?(:creator_staff)
        assert test.respond_to?(:for_staff)
        assert test.respond_to?(:user)
        assert test.respond_to?(:user_organization)
        assert test.respond_to?(:worker_staff)
    end

end
