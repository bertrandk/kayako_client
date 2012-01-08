$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'logger'
require 'rubygems'
require 'kayako_client'

# Configuration
client = KayakoClient::Base.new(
    'http://kayako.yourdomain.com/api/index.php?',
    '2fa87390-7160-54c4-e9ce-bec638a5a153',
    'Yzg3M2E3OWQtODM5MS1jNmY0LThkZjgtODJjZTU1MGE4MzcyYWY4NjQ2MTUtNDkxZS1lNDE0LTgxYzQtYWNjZmM5MzVjMmIz',
    :logger => Logger.new(STDOUT)
)

# Fetch departments
puts "Departments:"
departments = client.departments
departments.each do |department|
    puts " #{department.id}. #{department.title}"
end

# Fetch a department by :id
puts "Department:"
department = client.get_department(1)
department.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{department[property].inspect}"
end

# Fetch staff users
puts "Staff:"
staff = client.staff
staff.each do |user|
    puts " #{user.id}. #{user.user_name} (#{user.first_name} #{user.last_name} <#{user.email}>)"
end

# Fetch a staff user
puts "Staff member:"
staff = client.get_staff(1)
staff.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{staff[property].inspect}"
end

# Fetch staff groups
puts "Staff groups:"
groups = client.staff_groups
groups.each do |group|
    puts " #{group.id}. #{group.title}"
end

# Fetch a staff group
puts "Staff group:"
group = client.get_staff_group(1)
group.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{group[property].inspect}"
end

puts "Tickets:"
tickets = client.tickets(1)
tickets.each do |ticket|
    puts " #{ticket.id}. #{ticket.display_id}: #{ticket.subject} (#{ticket.ticket_status.title})"
end

puts "Ticket:"
ticket = client.get_ticket(1)
ticket.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    if ticket[property].is_a?(Array) || ticket[property].kind_of?(KayakoClient::Base)
        puts " o #{property}: <#{ticket[property].class}>"
    else
        puts " o #{property}: #{ticket[property].inspect}"
    end
end

puts "Search:"
tickets = client.ticket_search('Test', KayakoClient::Ticket::SEARCH_CONTENTS | KayakoClient::Ticket::SEARCH_NOTES || KayakoClient::Ticket::SEARCH_TAGS)
tickets.each do |ticket|
    puts " #{ticket.id}. #{ticket.display_id}: #{ticket.subject} (#{ticket.ticket_status.title})"
end

puts "Attachments:"
attachments = client.ticket_attachments(1)
attachments.each do |attachment|
    puts " #{attachment.id}. #{attachment.file_name} (#{attachment.file_size})"
end

puts "Attachment:"
attachment = client.get_ticket_attachment(1, 1)
attachment.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    next if property == :contents
    puts " o #{property}: #{attachment[property].inspect}"
end

puts "Count:"
count = client.ticket_count
puts " o Departments:"
count.departments.each do |department|
    puts "   * #{department.id}. #{department.department.title}: #{department.total_items} (#{department.total_unresolved_items})"
    puts "     Statuses:"
    department.statuses.each do |status|
        puts "     - #{status.id}. #{status.ticket_status.title}: #{status.total_items}"
    end
    puts "     Types:"
    department.types.each do |type|
        if type.id > 0
            puts "     - #{type.id}. #{type.ticket_type.title}: #{type.total_items}"
        else
            puts "     - #{type.id}. <none>: #{type.total_items}"
        end
    end
    puts "     Owners:"
    department.owners.each do |owner|
        if owner.id > 0
            puts "     - #{owner.id}. #{owner.owner_staff.full_name}: #{owner.total_items} (#{owner.total_unresolved_items})"
        else
            puts "     - #{owner.id}. <no one>: #{owner.total_items} (#{owner.total_unresolved_items})"
        end
    end
end
puts " o Statuses:"
count.statuses.each do |status|
    puts "   * #{status.id}. #{status.ticket_status.title}: #{status.total_items}"
end
puts " o Owners:"
count.owners.each do |owner|
    if owner.id > 0
        puts "   * #{owner.id}. #{owner.owner_staff.full_name}: #{owner.total_items} (#{owner.total_unresolved_items})"
    else
        puts "   * #{owner.id}. <no one>: #{owner.total_items} (#{owner.total_unresolved_items})"
    end
end
puts " o Unassigned:"
count.unassigned.each do |ticket|
    puts "   * #{ticket.id}: #{ticket.total_items} (#{ticket.total_unresolved_items})"
end

puts "Custom fields:"
fields = client.ticket_custom_fields(1)
if fields && !fields.empty?
    fields.groups.each do |group|
        puts " #{group.id}. #{group.title}"
        group.fields.each do |field|
            if field.type == KayakoClient::TicketCustomField::TYPE_FILE
                puts " #{group.id}.#{field.id}. #{field.title}: <file>"
            else
                puts " #{group.id}.#{field.id}. #{field.title}: #{field.contents}"
            end
        end
    end
end

puts "Notes:"
notes = client.ticket_notes(1)
notes.each do |note|
    puts " #{note.id}: #{note.contents} (#{note.creator_staff ? note.creator_staff.full_name : 'none'})"
end

puts "Note:"
note = client.get_ticket_note(1, 1)
note.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{note[property].inspect}"
end

puts "Posts:"
posts = client.ticket_posts(1)
posts.each do |post|
    puts " #{post.id}: #{post.contents} (#{post.full_name})"
end

puts "Post:"
post = client.get_ticket_post(1, 1)
post.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{post[property].inspect}"
end

puts "Priorities:"
priorities = client.ticket_priorities
priorities.each do |priority|
    puts " #{priority.id}. #{priority.title}"
end

puts "Priority:"
priority = client.get_ticket_priority(1)
priority.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{priority[property].inspect}"
end

puts "Statuses:"
statuses = client.ticket_statuses
statuses.each do |status|
    puts " #{status.id}. #{status.title} (#{status.mark_as_resolved? ? 'Closed' : 'Open'})"
end

puts "Status:"
status = client.get_ticket_status(1)
status.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{status[property].inspect}"
end

puts "Time tracks:"
tracks = client.ticket_time_tracks(1)
tracks.each do |track|
    puts " #{track.id}: #{track.time_worked / 3600} (#{track.worker_staff_name})"
end

puts "Time track:"
begin
    track = client.get_ticket_time_track(1, 1)
    track.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
        puts " o #{property}: #{track[property].inspect}"
    end
rescue StandardError
    puts "<not found>"
end

puts "Types:"
types = client.ticket_types
types.each do |type|
    puts " #{type.id}. #{type.title}"
end

puts "Type:"
type = client.get_ticket_type(1)
type.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{type[property].inspect}"
end

puts "Users:"
users = client.users(1, 100)
users.each do |user|
    puts " #{user.id}. #{user.email.first} (#{user.full_name}, #{user.user_role})"
end

puts "User:"
user = client.get_user(1)
user.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{user[property].inspect}"
end

puts "User groups:"
groups = client.user_groups
groups.each do |group|
    puts " #{group.id}. #{group.title}"
end

puts "User group:"
group = client.get_user_group(1)
group.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{group[property].inspect}"
end

puts "User organizations:"
organizations = client.user_organizations
organizations.each do |organization|
    puts " #{organization.id}. #{organization.name}"
end

puts "User organization:"
organization = client.get_user_organization(1)
organization.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{organization[property].inspect}"
end
