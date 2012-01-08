$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'logger'
require 'rubygems'
require 'kayako_client'

puts "Count:"
count = KayakoClient::TicketCount.new(
    'http://kayako.yourdomain.com/api/index.php?',
    '2fa87390-7160-54c4-e9ce-bec638a5a153',
    'Yzg3M2E3OWQtODM5MS1jNmY0LThkZjgtODJjZTU1MGE4MzcyYWY4NjQ2MTUtNDkxZS1lNDE0LTgxYzQtYWNjZmM5MzVjMmIz',
    :logger => Logger.new(STDOUT)
)

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
