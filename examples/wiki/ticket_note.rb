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

# Find first department of :tickets module
department = nil
KayakoClient::Department.all.each do |d|
    if d.module == :tickets
        department = d
        break
    end
end

# Find any status
status = KayakoClient::TicketStatus.all.first

# Find any priority
priority = KayakoClient::TicketPriority.all.first

# Find any type
type = KayakoClient::TicketType.all.first

# Create an instance
ticket = KayakoClient::Ticket.new(
    :department_id => department,
    :status_id     => status,
    :priority_id   => priority,
    :type_id       => type,
    :subject       => 'Example ticket subject',
    :contents      => 'Example ticket details.'
)

# Set user details
ticket.full_name    = 'John Doe'
ticket.email        = 'foo@example.com'
ticket.auto_user_id = true

# Post ticket
ticket.post

# Post a note
KayakoClient::TicketNote.post(
    :ticket_id => ticket,
    :full_name => 'John Doe',
    :contents  => 'Example note content.'
)
