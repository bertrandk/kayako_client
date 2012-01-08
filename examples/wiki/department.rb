$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../lib')))

require 'logger'
require 'rubygems'
require 'kayako_client'

# Configure
KayakoClient::Base.configure do |config|
    config.api_url    = 'http://kayako.yourdomain.com/api/index.php?'
    config.api_key    = '2fa87390-7160-54c4-e9ce-bec638a5a153'
    config.secret_key = 'Yzg3M2E3OWQtODM5MS1jNmY0LThkZjgtODJjZTU1MGE4MzcyYWY4NjQ2MTUtNDkxZS1lNDE0LTgxYzQtYWNjZmM5MzVjMmIz'
    config.logger     = Logger.new(STDOUT)
end

# Create an instance
department = KayakoClient::Department.new(
    :title  => 'Customer Support',
    :type   => :public,
    :module => :tickets
)

# Save
department.post
