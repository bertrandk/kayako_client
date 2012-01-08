require 'test/unit'
require 'kayako_client'

class TestClient < Test::Unit::TestCase

    def test_client_base
        test = KayakoClient::Base.new

        assert test.respond_to?(:departments)
        assert test.respond_to?(:get_department)
        assert test.respond_to?(:post_department)
        assert test.respond_to?(:delete_department)
        assert test.respond_to?(:staff)
        assert test.respond_to?(:get_staff)
        assert test.respond_to?(:post_staff)
        assert test.respond_to?(:delete_staff)
        assert test.respond_to?(:staff_groups)
        assert test.respond_to?(:get_staff_group)
        assert test.respond_to?(:post_staff_group)
        assert test.respond_to?(:delete_staff_group)
        assert test.respond_to?(:tickets)
        assert test.respond_to?(:get_ticket)
        assert test.respond_to?(:ticket_search)
        assert test.respond_to?(:post_ticket)
        assert test.respond_to?(:delete_ticket)
        assert test.respond_to?(:ticket_attachments)
        assert test.respond_to?(:get_ticket_attachment)
        assert test.respond_to?(:post_ticket_attachment)
        assert test.respond_to?(:delete_ticket_attachment)
        assert test.respond_to?(:ticket_count)
        assert test.respond_to?(:ticket_custom_fields)
        assert test.respond_to?(:ticket_notes)
        assert test.respond_to?(:get_ticket_note)
        assert test.respond_to?(:post_ticket_note)
        assert test.respond_to?(:delete_ticket_note)
        assert test.respond_to?(:ticket_posts)
        assert test.respond_to?(:get_ticket_post)
        assert test.respond_to?(:post_ticket_post)
        assert test.respond_to?(:delete_ticket_post)
        assert test.respond_to?(:ticket_priorities)
        assert test.respond_to?(:get_ticket_priority)
        assert test.respond_to?(:ticket_statuses)
        assert test.respond_to?(:get_ticket_status)
        assert test.respond_to?(:ticket_time_tracks)
        assert test.respond_to?(:get_ticket_time_track)
        assert test.respond_to?(:post_ticket_time_track)
        assert test.respond_to?(:delete_ticket_time_track)
        assert test.respond_to?(:ticket_types)
        assert test.respond_to?(:get_ticket_type)
        assert test.respond_to?(:users)
        assert test.respond_to?(:get_user)
        assert test.respond_to?(:post_user)
        assert test.respond_to?(:delete_user)
        assert test.respond_to?(:user_groups)
        assert test.respond_to?(:get_user_group)
        assert test.respond_to?(:post_user_group)
        assert test.respond_to?(:delete_user_group)
        assert test.respond_to?(:user_organizations)
        assert test.respond_to?(:get_user_organization)
        assert test.respond_to?(:post_user_organization)
        assert test.respond_to?(:delete_user_organization)

        assert test.respond_to?(:find_department)
        assert test.respond_to?(:create_department)
        assert test.respond_to?(:destroy_department)
        assert test.respond_to?(:staff_users)
        assert test.respond_to?(:find_staff)
        assert test.respond_to?(:create_staff)
        assert test.respond_to?(:destroy_staff)
        assert test.respond_to?(:find_staff_group)
        assert test.respond_to?(:create_staff_group)
        assert test.respond_to?(:destroy_staff_group)
        assert test.respond_to?(:find_ticket)
        assert test.respond_to?(:create_ticket)
        assert test.respond_to?(:destroy_ticket)
        assert test.respond_to?(:find_ticket_attachment)
        assert test.respond_to?(:create_ticket_attachment)
        assert test.respond_to?(:destroy_ticket_attachment)
        assert test.respond_to?(:find_ticket_note)
        assert test.respond_to?(:create_ticket_note)
        assert test.respond_to?(:destroy_ticket_note)
        assert test.respond_to?(:find_ticket_post)
        assert test.respond_to?(:create_ticket_post)
        assert test.respond_to?(:destroy_ticket_post)
        assert test.respond_to?(:find_ticket_priority)
        assert test.respond_to?(:find_ticket_status)
        assert test.respond_to?(:find_ticket_time_track)
        assert test.respond_to?(:create_ticket_time_track)
        assert test.respond_to?(:destroy_ticket_time_track)
        assert test.respond_to?(:find_ticket_type)
        assert test.respond_to?(:find_user)
        assert test.respond_to?(:create_user)
        assert test.respond_to?(:destroy_user)
        assert test.respond_to?(:find_user_group)
        assert test.respond_to?(:create_user_group)
        assert test.respond_to?(:destroy_user_group)
        assert test.respond_to?(:find_user_organization)
        assert test.respond_to?(:create_user_organization)
        assert test.respond_to?(:destroy_user_organization)

        test = KayakoClient::Ticket.new

        assert !test.respond_to?(:get_ticket)
        assert !test.respond_to?(:get_ticket_post)
        assert !test.respond_to?(:user_organizations)
        assert !test.respond_to?(:find_staff_group)
        assert !test.respond_to?(:find_user_group)
    end

    def test_client_ticket
        assert KayakoClient::Ticket.respond_to?(:count)

        test = KayakoClient::Ticket.new

        assert test.respond_to?(:attachments)
        assert test.respond_to?(:get_attachment)
        assert test.respond_to?(:post_attachment)
        assert test.respond_to?(:delete_attachment)
        assert test.respond_to?(:custom_fields)
        assert test.respond_to?(:notes)
        assert test.respond_to?(:get_note)
        assert test.respond_to?(:post_note)
        assert test.respond_to?(:delete_note)
        assert test.respond_to?(:get_post)
        assert test.respond_to?(:post_post)
        assert test.respond_to?(:delete_post)
        assert test.respond_to?(:time_tracks)
        assert test.respond_to?(:get_time_track)
        assert test.respond_to?(:post_time_track)
        assert test.respond_to?(:delete_time_track)

        assert test.respond_to?(:find_attachment)
        assert test.respond_to?(:create_attachment)
        assert test.respond_to?(:destroy_attachment)
        assert test.respond_to?(:find_note)
        assert test.respond_to?(:create_note)
        assert test.respond_to?(:destroy_note)
        assert test.respond_to?(:find_post)
        assert test.respond_to?(:create_post)
        assert test.respond_to?(:destroy_post)
        assert test.respond_to?(:find_time_track)
        assert test.respond_to?(:create_time_track)
        assert test.respond_to?(:destroy_time_track)

        test = KayakoClient::Base.new

        assert !test.respond_to?(:attachments)
        assert !test.respond_to?(:custom_fields)
        assert !test.respond_to?(:delete_post)
        assert !test.respond_to?(:create_attachment)
        assert !test.respond_to?(:find_post)
    end

    def test_client_inheritance
        require 'kayako_client/http/http_client'
        require 'kayako_client/http/net_http'

        nethttp = KayakoClient::NetHTTP.new
        httpclient = KayakoClient::HTTPClient.new

        KayakoClient::Base.http_backend = nethttp
        assert_equal nethttp.object_id, KayakoClient::Base.client.object_id

        instance = KayakoClient::User.new
        assert_equal nethttp.object_id, instance.client.object_id

        client = KayakoClient::Base.new
        client.http_backend = httpclient

        assert_equal httpclient.object_id, client.client.object_id
        assert_not_equal client.client.object_id, nethttp.object_id
    end

end
