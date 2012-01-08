require 'test/unit'
require 'kayako_client'

class TestConfiguration < Test::Unit::TestCase

    API_URL    = 'http://restapi.kayako.com/api/index.php?'
    API_KEY    = '2fa87390-7160-54c4-e9ce-bec638a5a153'
    SECRET_KEY = 'Yzg3M2E3OWQtODM5MS1jNmY0LThkZjgtODJjZTU1MGE4MzcyYWY4NjQ2MTUtNDkxZS1lNDE0LTgxYzQtYWNjZmM5MzVjMmIz'

    def test_001_no_configuration
        assert_equal KayakoClient::Base.api_url, ''
        assert_equal KayakoClient::Base.api_key, ''
        assert_equal KayakoClient::Base.secret_key, ''

        assert_raise RuntimeError do
            KayakoClient::StaffGroup.get(1)
        end
        assert_raise RuntimeError do
            KayakoClient::StaffGroup.post(
                :title    => 'Test',
                :is_admin => true
            )
        end

        test = KayakoClient::StaffGroup.new
        assert_raise RuntimeError do
            test.post
        end
    end

    def test_002_instance_configuration
        instance1 = KayakoClient::Base.new(API_URL, API_KEY, SECRET_KEY)
        instance2 = KayakoClient::Base.new

        assert_equal instance1.api_url, API_URL
        assert_equal instance1.api_key, API_KEY
        assert_equal instance1.secret_key, SECRET_KEY

        assert_equal instance2.api_url, ''
        assert_equal instance2.api_key, ''
        assert_equal instance2.secret_key, ''
    end

    def test_003_global_configuration
        KayakoClient::Base.configure do |config|
            config.api_url = API_URL
            config.api_key = API_KEY
        end
        assert_equal KayakoClient::Base.api_url, API_URL
        assert_equal KayakoClient::Base.api_key, API_KEY

        KayakoClient::Base.secret_key = SECRET_KEY
        assert_equal KayakoClient::Base.secret_key, SECRET_KEY

        assert_equal KayakoClient::StaffGroup.new.api_key, API_KEY
    end

    def test_004_http_backend
        assert_raise ArgumentError do
            KayakoClient::Base.http_backend = 'This should be a class name!'
        end

        assert_raise LoadError do
            KayakoClient::Base.http_backend = 'NotExistingHTTPBackendClass'
        end

        assert_nothing_raised do
            KayakoClient::Base.http_backend = 'NetHTTP'
        end
    end

    def test_005_xml_backend
        assert_raise ArgumentError do
            KayakoClient::Base.xml_backend = 'This should be a class name!'
        end

        assert_raise LoadError do
            KayakoClient::Base.xml_backend = 'NotExistingXMLBackendClass'
        end

        assert_nothing_raised do
            KayakoClient::Base.xml_backend = 'REXMLDocument'
        end

        assert_nothing_raised do
            KayakoClient::Base.xml_backend = 'LibXML'
        end
    end

    def test_006_http_configuration
        KayakoClient::Base.proxy = { :host => '127.0.0.1', :port => 3128 }
        assert_equal KayakoClient::Base.proxy[:host], '127.0.0.1'
        assert_equal KayakoClient::Base.proxy[:port], 3128
    end

end
