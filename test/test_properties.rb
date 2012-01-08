require 'test/unit'
require 'kayako_client'

class TestProperties < Test::Unit::TestCase

    def test_new
        test = KayakoClient::StaffGroup.new
        assert test.new?

        test.loaded!
        assert !test.new?
    end

    def test_changed
        test = KayakoClient::StaffGroup.new
        assert !test.changed?

        test.title = 'Test'
        assert test.changed?

        test.loaded!
        assert !test.changed?
    end

    def test_identifier
        test = KayakoClient::StaffGroup.new
        assert test.to_i, 0
    end

    def test_array_accessor
        test = KayakoClient::StaffGroup.new(
            :title    => 'Administrators',
            :is_admin => true
        )

        assert_raise ArgumentError do
            test[:test] = 'Test'
        end

        assert_raise ArgumentError do
            test[:id] = 1
        end

        assert_nothing_raised do
            test[:title] = 'Test'
        end

        assert_nil test[:id]

        test = KayakoClient::TicketWorkflow.new(
            :id    => 1,
            :title => 'Test'
        )

        assert_raise ArgumentError do
            test[:title] = 'Test'
        end

        assert_nil test[:test]
        assert_not_nil test[:title]
    end

    def test_accessor
        test = KayakoClient::StaffGroup.new(
            :title    => 'Administrators',
            :is_admin => true
        )

        assert_raise NoMethodError do
            test.id = 1
        end

        assert_nil test.id
        assert_equal test.title, 'Administrators'

        test = KayakoClient::TicketWorkflow.new(
            :id    => 1,
            :title => 'Test'
        )

        assert_raise NoMethodError do
            test.title = 'Test'
        end

        assert_equal test.id, 1
        assert_equal test.title, 'Test'
    end

    def test_embedded
        assert KayakoClient::TicketWorkflow.embedded?, true
    end

    def test_path
        assert_equal KayakoClient::User.path, '/Base/User'
        assert_equal KayakoClient::Staff.path, '/Base/Staff'
        assert_equal KayakoClient::Ticket.path, '/Tickets/Ticket'
        assert_equal KayakoClient::TicketType.path, '/Tickets/TicketType'
    end

end
