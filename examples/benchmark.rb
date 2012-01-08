$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'rubygems'
require 'kayako_client'

require 'benchmark'

client = KayakoClient::Base.new(
    'http://kayako.yourdomain.com/api/index.php?',
    '2fa87390-7160-54c4-e9ce-bec638a5a153',
    'Yzg3M2E3OWQtODM5MS1jNmY0LThkZjgtODJjZTU1MGE4MzcyYWY4NjQ2MTUtNDkxZS1lNDE0LTgxYzQtYWNjZmM5MzVjMmIz'
)

puts "Net::HTTP + REXML::Document:"

client.http_backend = 'NetHTTP'
client.xml_backend = 'REXMLDocument'

Benchmark.bm do |x|
    x.report 'Staff' do
        client.staff
    end
    x.report 'Users' do
        client.users
    end
    x.report 'Statistics' do
        client.ticket_count
    end
end

puts "Net::HTTP + LibXML:"

client.http_backend = 'NetHTTP'
client.xml_backend = 'LibXML'

Benchmark.bm do |x|
    x.report 'Staff' do
        client.staff
    end
    x.report 'Users' do
        client.users
    end
    x.report 'Statistics' do
        client.ticket_count
    end
end

puts "HTTPClient + REXML::Document:"

client.http_backend = 'HTTPClient'
client.xml_backend = 'REXMLDocument'

Benchmark.bm do |x|
    x.report 'Staff' do
        client.staff
    end
    x.report 'Users' do
        client.users
    end
    x.report 'Statistics' do
        client.ticket_count
    end
end

puts "HTTPClient + LibXML:"

client.http_backend = 'HTTPClient'
client.xml_backend = 'LibXML'

Benchmark.bm do |x|
    x.report 'Staff' do
        client.staff
    end
    x.report 'Users' do
        client.users
    end
    x.report 'Statistics' do
        client.ticket_count
    end
end
