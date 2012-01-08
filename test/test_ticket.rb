require 'test/unit'
require 'kayako_client'

class TestTicket < Test::Unit::TestCase

    def test_ticket_readonly
        test = KayakoClient::Ticket.new(
            :contents => 'Test',
            :auto_user_id => true,
            :type => :default
        )

        assert_raise NoMethodError do
            test.display_id = 'OLJ-171-16930'
        end

        assert_raise NoMethodError do
            test.creation_time = Time.new
        end

        assert_nothing_raised do
            test.contents = 'Test'
            test.auto_user_id = true
            test.type = :default
        end

        test.loaded!
        assert_raise ArgumentError do
            test.contents = 'Test'
            test.auto_user_id = true
            test.type = :default
        end
    end

    def test_ticket_constants
        assert_nothing_raised do
            test = KayakoClient::Ticket::FLAG_NONE
            test = KayakoClient::Ticket::FLAG_ORANGE
            test = KayakoClient::Ticket::FLAG_BLUE
        end
    end

    def test_ticket_verification
        test = KayakoClient::Ticket.new(
            :department_id => 1,
            :status_id     => 1,
            :priority_id   => 1,
            :type_id       => 1,
            :full_name     => 'Test Tester',
            :email         => 'test@test.com',
            :subject       => 'Test',
            :contents      => 'Test'
        )

        assert_raise ArgumentError do
            test.post
        end

        test.user_id = 1
        test.type = :test

        assert test.post == false
        assert test.has_errors?
    end

    def test_ticket_embedded
        test = KayakoClient::Ticket.new(
            :work_flow => {
                :id    => 1,
                :title => 'Test'
            },
            :watcher => {
                :staff_id => 1,
                :name     => 'Test'
            }
        )

        assert_instance_of KayakoClient::TicketWorkflow, test.work_flow
        assert_instance_of Array, test.watcher
        assert_instance_of KayakoClient::TicketWatcher, test.watcher.first

        assert_equal test.work_flow.title, 'Test'
        assert_equal test.watcher.first.name, 'Test'
    end

    def test_ticket_assign
        test = KayakoClient::Ticket.new(
            :id => '1',
            :creation_time => '1310922585',
            :is_escalated => '0'
        )

        assert_equal test.id, 1
        assert_instance_of Time, test.creation_time
        assert_equal test.creation_time.to_i, 1310922585
        assert_instance_of FalseClass, test.is_escalated
        assert test.is_escalated == false
    end

    def test_ticket_search
        assert KayakoClient::Ticket.respond_to?(:search)

        assert_equal 0x07FF,
            KayakoClient::Ticket::SEARCH_TICKET_ID         |
            KayakoClient::Ticket::SEARCH_CONTENTS          |
            KayakoClient::Ticket::SEARCH_AUTHOR            |
            KayakoClient::Ticket::SEARCH_EMAIL             |
            KayakoClient::Ticket::SEARCH_CREATOR_EMAIL     |
            KayakoClient::Ticket::SEARCH_FULL_NAME         |
            KayakoClient::Ticket::SEARCH_NOTES             |
            KayakoClient::Ticket::SEARCH_USER_GROUP        |
            KayakoClient::Ticket::SEARCH_USER_ORGANIZATION |
            KayakoClient::Ticket::SEARCH_USER              |
            KayakoClient::Ticket::SEARCH_TAGS

    end

end
