require 'test/unit'
require 'kayako_client'

class TestCustomField < Test::Unit::TestCase

    def test_custom_field_embedded
        test = KayakoClient::TicketCustomField.new(
            :group => {
                :id     => 1,
                :title  => 'Test',
                :fields => [ {
                        :id       => 1,
                        :type     => KayakoClient::TicketCustomField::TYPE_TEXT,
                        :title    => 'Text',
                        :contents => 'Test'
                    }, {
                        :id       => 2,
                        :type     => KayakoClient::TicketCustomField::TYPE_TEXT_AREA,
                        :title    => 'Text area',
                        :contents => 'Test'
                    }, {
                        :id       => 3,
                        :type     => KayakoClient::TicketCustomField::TYPE_PASSWORD,
                        :title    => 'Password',
                        :contents => 'Test'
                    }, {
                        :id       => 4,
                        :type     => KayakoClient::TicketCustomField::TYPE_CHECKBOX,
                        :title    => 'Checkbox',
                        :contents => 'Test'
                    }, {
                        :id       => 5,
                        :type     => KayakoClient::TicketCustomField::TYPE_RADIO,
                        :title    => 'Radio',
                        :contents => 'Test'
                    }, {
                        :id       => 6,
                        :type     => KayakoClient::TicketCustomField::TYPE_SELECT,
                        :title    => 'Select',
                        :contents => 'Test'
                    }, {
                        :id       => 7,
                        :type     => KayakoClient::TicketCustomField::TYPE_MULTI_SELECT,
                        :title    => 'Multiselect',
                        :contents => 'Test, Item'
                    }, {
                        :id       => 8,
                        :type     => KayakoClient::TicketCustomField::TYPE_CUSTOM,
                        :title    => 'Custom',
                        :contents => 'Test'
                    }, {
                        :id       => 9,
                        :type     => KayakoClient::TicketCustomField::TYPE_LINKED_SELECT,
                        :title    => 'Linked select',
                        :contents => 'Test &gt; Test'
                    }, {
                        :id       => 10,
                        :type     => KayakoClient::TicketCustomField::TYPE_DATE,
                        :title    => 'Date',
                        :contents => '05/24/2011'
                    }, {
                        :id       => 11,
                        :type     => KayakoClient::TicketCustomField::TYPE_FILE,
                        :title    => 'File',
                        :filename => 'test.txt',
                        :contents => 'VTI5dFpTQjBaWE4wSUhOMGNtbHVaeTQ9' # Some test string.
                } ]
            }
        )

        assert_instance_of Array, test.groups
        assert_instance_of KayakoClient::TicketCustomFieldGroup, test.groups.first
        assert_equal test.groups.size, 1

        assert_equal test.groups.first.id, 1
        assert_equal test.groups.first.title, 'Test'

        assert_instance_of Array, test.groups.first.fields
        assert_instance_of KayakoClient::TicketCustomFieldValue, test.groups.first.fields.first
        assert_equal test.groups.first.fields.size, 11

        assert_equal test.groups.first.fields.first.id, 1
        assert_equal test.groups.first.fields.first.type, KayakoClient::TicketCustomField::TYPE_TEXT
        assert_equal test.groups.first.fields.first.title, 'Text'
        assert_nil test.groups.first.fields.first.file_name
        assert_equal test.groups.first.fields.first.contents, 'Test'

        assert_instance_of Time, test.groups.first.fields[9].contents
        assert_equal test.groups.first.fields[9].contents.strftime('%m/%d/%Y'), '05/24/2011'

        assert_equal test.groups.first.fields.last.file_name, 'test.txt'
        assert_equal test.groups.first.fields.last.contents, 'Some test string.'
    end

    def test_custom_field_file
        test = KayakoClient::TicketCustomFieldValue.new(
            :id       => 11,
            :type     => KayakoClient::TicketCustomField::TYPE_FILE,
            :title    => 'File',
            :filename => 'test.txt',
            :contents => 'VTI5dFpTQjBaWE4wSUhOMGNtbHVaeTQ9' # Some test string.
        )
        test.loaded!
        assert_instance_of Tempfile, test.file
        assert_equal test.file.read, 'Some test string.'
    end

    def test_custom_field_customs
        test = KayakoClient::TicketCustomField.new

        assert test.respond_to?(:empty?)
        assert test.empty?

        test = KayakoClient::TicketCustomField.new(
            :group => {
                :id     => 1,
                :title  => 'Test',
                :fields => [ {
                        :id       => 4,
                        :type     => KayakoClient::TicketCustomField::TYPE_CHECKBOX,
                        :title    => 'Checkbox',
                        :contents => 'Test'
                    }, {
                        :id       => 9,
                        :type     => KayakoClient::TicketCustomField::TYPE_LINKED_SELECT,
                        :title    => 'Linked select',
                        :contents => 'Test &gt; Test'
                } ]
            }
        )

        assert_equal test.custom_field(4), 'Test'
        assert_equal test.custom_field('Linked select'), 'Test &gt; Test'
        assert_nil test.custom_field('Does not exist')

        assert_equal test[9], 'Test &gt; Test'
        assert_equal test['Checkbox'], 'Test'
        assert_nil test[20]

        assert_instance_of Array, test['groups']
        assert_instance_of Array, test[:groups]

        assert test.respond_to?(:each)
    end

end
