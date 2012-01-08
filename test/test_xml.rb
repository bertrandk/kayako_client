require 'test/unit'
require 'kayako_client'

class TestXML < Test::Unit::TestCase

    PHP_ERROR = '<div style="BACKGROUND: #f8ebeb; FONT: 13px Trebuchet MS, Verdana, Helvetica, Arial; BORDER: 1px SOLID #751616; PADDING: 10px; MARGIN: 5px;">' +
                '<font color="red">' +
                '[Warning]: Missing argument 2 for Controller_TicketAttachment::Get() (api/class.Controller_TicketAttachment.php:172)' +
                '</font>' +
                '</div>'

    def test_xml_php_error
        xml = KayakoClient::REXMLDocument.new(PHP_ERROR)

        assert xml.error?
        assert_equal xml.error, '[Warning]: Missing argument 2 for Controller_TicketAttachment::Get() (api/class.Controller_TicketAttachment.php:172)'
        assert_equal xml.count, 0
        assert_nil xml.to_hash

        xml = KayakoClient::LibXML.new(PHP_ERROR)

        assert xml.error?
        assert_equal xml.error, '[Warning]: Missing argument 2 for Controller_TicketAttachment::Get() (api/class.Controller_TicketAttachment.php:172)'
        assert_equal xml.count, 0
        assert_nil xml.to_hash
    end

    STAFF_GROUPS = '<?xml version="1.0" encoding="UTF-8"?>' +
                   '<staffgroups>' +
                   '<staffgroup>' +
                   '<id><![CDATA[1]]></id>' +
                   '<title><![CDATA[Administrators]]></title>' +
                   '<isadmin><![CDATA[1]]></isadmin>' +
                   '</staffgroup>' +
                   '<staffgroup>' +
                   '<id><![CDATA[2]]></id>' +
                   '<title><![CDATA[Employees]]></title>' +
                   '<isadmin><![CDATA[0]]></isadmin>' +
                   '</staffgroup>' +
                   '<staffgroup>' +
                   '<id><![CDATA[3]]></id>' +
                   '<title><![CDATA[Users]]></title>' +
                   '<isadmin><![CDATA[0]]></isadmin>' +
                   '</staffgroup>' +
                   '<staffgroup>' +
                   '<id><![CDATA[5]]></id>' +
                   '<title><![CDATA[Testers]]></title>' +
                   '<isadmin><![CDATA[0]]></isadmin>' +
                   '</staffgroup>' +
                   '</staffgroups>'

    def test_xml_staff_groups
        xml = KayakoClient::REXMLDocument.new(STAFF_GROUPS)
        test = xml.to_hash

        assert_equal xml.count, 4
        assert_instance_of Array, test[:staffgroup]
        assert_equal test[:staffgroup].size, 4
        assert_instance_of Hash, test[:staffgroup].first
        assert_equal test[:staffgroup].first[:id], 1.to_s
        assert_equal test[:staffgroup].first[:title], 'Administrators'

        xml = KayakoClient::LibXML.new(STAFF_GROUPS)
        test = xml.to_hash

        assert_equal xml.count, 4
        assert_instance_of Array, test[:staffgroup]
        assert_equal test[:staffgroup].size, 4
        assert_instance_of Hash, test[:staffgroup].first
        assert_equal test[:staffgroup].first[:id], 1.to_s
        assert_equal test[:staffgroup].first[:title], 'Administrators'
    end

    TICKET_COUNT = '<?xml version="1.0" encoding="UTF-8"?>' +
                   '<ticketcount>' +
                   '<departments>' +
                   '<department id="3">' +
                   '<totalitems><![CDATA[5]]></totalitems>' +
                   '<lastactivity><![CDATA[1311888965]]></lastactivity>' +
                   '<totalunresolveditems><![CDATA[5]]></totalunresolveditems>' +
                   '<ticketstatus id="1" lastactivity="1311888965" totalitems="5" />' +
                   '<tickettype id="0" lastactivity="1311888965" totalitems="5" totalunresolveditems="5" />' +
                   '<ownerstaff id="0" lastactivity="1311888396" totalitems="1" totalunresolveditems="1" />' +
                   '<ownerstaff id="1" lastactivity="1311887337" totalitems="2" totalunresolveditems="2" />' +
                   '<ownerstaff id="3" lastactivity="1311888965" totalitems="2" totalunresolveditems="2" />' +
                   '</department>' +
                   '<department id="5">' +
                   '<totalitems><![CDATA[1]]></totalitems>' +
                   '<lastactivity><![CDATA[1313153933]]></lastactivity>' +
                   '<totalunresolveditems><![CDATA[1]]></totalunresolveditems>' +
                   '<ticketstatus id="1" lastactivity="1313153933" totalitems="1" />' +
                   '<tickettype id="0" lastactivity="1313153933" totalitems="1" totalunresolveditems="1" />' +
                   '<ownerstaff id="3" lastactivity="1313153933" totalitems="1" totalunresolveditems="1" />' +
                   '</department>' +
                   '</departments>' +
                   '<!-- Ticket Count grouped by Status -->' +
                   '<statuses>' +
                   '<ticketstatus id="1" lastactivity="1313153933" totalitems="6" />' +
                   '</statuses>' +
                   '<!-- Ticket Count grouped by Owner Staff -->' +
                   '<owners>' +
                   '<ownerstaff id="0" lastactivity="1311888396" totalitems="1" totalunresolveditems="1" />' +
                   '<ownerstaff id="1" lastactivity="1311887337" totalitems="2" totalunresolveditems="2" />' +
                   '<ownerstaff id="3" lastactivity="1311888965" totalitems="2" totalunresolveditems="2" />' +
                   '</owners>' +
                   '<!-- Unassigned Ticket Count grouped by Department -->' +
                   '<unassigned>' +
                   '<department id="1" lastactivity="1311888396" totalitems="1" totalunresolveditems="1" />' +
                   '<department id="2" lastactivity="1311888396" totalitems="1" totalunresolveditems="1" />' +
                   '<department id="4" lastactivity="1311888396" totalitems="1" totalunresolveditems="1" />' +
                   '<department id="3" lastactivity="1311888396" totalitems="1" totalunresolveditems="1" />' +
                   '</unassigned>' +
                   '</ticketcount>'

    def test_xml_ticket_count
        xml = KayakoClient::REXMLDocument.new(TICKET_COUNT)
        test = xml.to_hash

        assert test.has_key?(:departments)
        assert test.has_key?(:statuses)
        assert test.has_key?(:owners)
        assert test.has_key?(:unassigned)

        assert_equal test[:departments].size, 1
        assert_equal test[:statuses].size, 1
        assert_equal test[:owners].size, 1
        assert_equal test[:unassigned].size, 1

        assert_instance_of Array, test[:departments][:department]
        assert_instance_of Hash, test[:statuses][:ticketstatus]
        assert_instance_of Array, test[:owners][:ownerstaff]
        assert_instance_of Array, test[:unassigned][:department]

        assert_equal test[:departments][:department].size, 2
        assert_equal test[:owners][:ownerstaff].size, 3
        assert_equal test[:unassigned][:department].size, 4

        assert_equal test[:departments][:department][0][:id], 3.to_s
        assert_equal test[:owners][:ownerstaff][1][:id], 1.to_s
        assert_equal test[:unassigned][:department][2][:id], 4.to_s

        xml = KayakoClient::LibXML.new(TICKET_COUNT)
        test = xml.to_hash

        assert test.has_key?(:departments)
        assert test.has_key?(:statuses)
        assert test.has_key?(:owners)
        assert test.has_key?(:unassigned)

        assert_equal test[:departments].size, 1
        assert_equal test[:statuses].size, 1
        assert_equal test[:owners].size, 1
        assert_equal test[:unassigned].size, 1

        assert_instance_of Array, test[:departments][:department]
        assert_instance_of Hash, test[:statuses][:ticketstatus]
        assert_instance_of Array, test[:owners][:ownerstaff]
        assert_instance_of Array, test[:unassigned][:department]

        assert_equal test[:departments][:department].size, 2
        assert_equal test[:owners][:ownerstaff].size, 3
        assert_equal test[:unassigned][:department].size, 4

        assert_equal test[:departments][:department][0][:id], 3.to_s
        assert_equal test[:owners][:ownerstaff][1][:id], 1.to_s
        assert_equal test[:unassigned][:department][2][:id], 4.to_s
    end

end
