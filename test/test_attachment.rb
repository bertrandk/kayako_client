require 'test/unit'
require 'kayako_client'

class TestAttachment < Test::Unit::TestCase

    def test_attachment_put
        test = KayakoClient::TicketAttachment.new
        assert_raise NotImplementedError do
            test.put
        end
    end

    def test_attachment_file
        test = KayakoClient::TicketAttachment.new(
            :file => __FILE__
        )
        assert_equal test.file_name, File.basename(__FILE__)
        assert_equal test.contents.size, File.size?(__FILE__)

        assert_raise RuntimeError do
            file = test.file
        end

        test = KayakoClient::TicketAttachment.new(
            :id        => 1,
            :file_name => 'test.txt',
            :contents  => 'Test file content.'
        )
        test.loaded!
        assert_instance_of Tempfile, test.file

        assert_equal test.file_name, 'test.txt'
        assert_equal test.contents, 'Test file content.'
    end

    def test_attachment_api
        test = KayakoClient::TicketAttachment.new(
            :id             => 1,
            :ticket_id      => 1,
            :ticket_post_id => 1,
            :file_name      => 'test.txt'
        )
        assert_nil test.contents

        test.loaded!
        assert_raise RuntimeError do
            test.contents
        end

        assert_raise ArgumentError do
            KayakoClient::TicketAttachment.all
        end

        assert_raise ArgumentError do
            KayakoClient::TicketAttachment.get(1)
        end

        assert_raise ArgumentError do
            KayakoClient::TicketAttachment.delete(1)
        end
    end

end
