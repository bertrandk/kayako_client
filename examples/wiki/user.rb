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

# Find first group of :registered type
user_group = nil
groups = KayakoClient::UserGroup.all
groups.each do |group|
    if group.group_type == :registered
        user_group = group
        break
    end
end

# Find first user organization
user_organization = KayakoClient::UserOrganization.all.first

# Create an instance
user = KayakoClient::User.new(
    :user_role          => :user,
    :salutation         => 'Mr.',
    :full_name          => 'John Doe',
    :emails             => 'foo@example.com',
    :password           => 'easypass332',
    :send_welcome_email => true
)

# Change some properties
user.user_group_id        = user_group
user.user_organization_id = user_organization

# Save
user.post
