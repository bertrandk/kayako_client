$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'logger'
require 'rubygems'
require 'kayako_client'

# Configuration
KayakoClient::Base.configure do |config|
    config.api_url    = 'http://kayako.yourdomain.com/api/index.php?'
    config.api_key    = '2fa87390-7160-54c4-e9ce-bec638a5a153'
    config.secret_key = 'Yzg3M2E3OWQtODM5MS1jNmY0LThkZjgtODJjZTU1MGE4MzcyYWY4NjQ2MTUtNDkxZS1lNDE0LTgxYzQtYWNjZmM5MzVjMmIz'
    config.logger     = Logger.new(STDOUT)
end

ticket = KayakoClient::Ticket.get(1)

puts "Attachments:"
attachments = ticket.attachments
attachments.each do |attachment|
    puts " #{attachment.id}. #{attachment.file_name} (#{attachment.file_size})"
end

puts "Attachment:"
attachment = ticket.get_attachment(1)
attachment.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    next if property == :contents
    puts " o #{property}: #{attachment[property].inspect}"
end

puts "Count:"
count = KayakoClient::Ticket.count
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
count.unassigned.each do |unassigned|
    puts "   * #{unassigned.id}: #{unassigned.total_items} (#{unassigned.total_unresolved_items})"
end

puts "Custom fields:"
fields = ticket.custom_fields
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
notes = ticket.notes
notes.each do |note|
    puts " #{note.id}: #{note.contents} (#{note.creator_staff ? note.creator_staff.full_name : 'none'})"
end

puts "Note:"
note = ticket.get_note(1)
note.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{note[property].inspect}"
end

puts "Post:"
post = ticket.get_post(1)
post.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
    puts " o #{property}: #{post[property].inspect}"
end

puts "Time tracks:"
tracks = ticket.time_tracks
tracks.each do |track|
    puts " #{track.id}: #{track.time_worked / 3600} (#{track.worker_staff_name})"
end

puts "Time track:"
begin
    track = ticket.get_time_track(1)
    track.properties.sort { |a,b| a.to_s.size <=> b.to_s.size } .each do |property|
        puts " o #{property}: #{track[property].inspect}"
    end
rescue StandardError
    puts "<not found>"
end
