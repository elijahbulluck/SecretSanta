require 'twilio-ruby'


#initialize participants array
participants = []

# Get all Twilio credentials from the user to be used in sending the SMS message
puts 'Enter your Twilio Account SID:'
acc_sid = gets.chomp

puts 'Enter your Twilio Authorization Token:'
auth_token = gets.chomp

puts 'Enter your Twilio phone number:'
twilio_phone_num = gets.chomp

#start the client
client = Twilio::REST::Client.new(acc_sid, auth_token)

puts 'Enter the name and phone number for each participant. When you are finished, type "done".'

loop do
  puts 'Enter participant name (or "done"):'
  name = gets.chomp

  break if name.downcase == 'done'

  puts "Enter #{name}'s phone number:"
  phone_number = gets.chomp

  participants << { name: name, phone_number: phone_number }
end

# After the participants have been entered, shuffle them
participants.shuffle!

# Assign Secret Santas and send SMS
participants.each_with_index do |gifter, i|
  receiver = participants[(i + 1) % participants.length]

  # Extract participant information
  gifter_name = gifter[:name]
  gifter_phone_num = gifter[:phone_number]

  # Create a message
  message = "Hello #{gifter_name}, your Secret Santa is #{receiver[:name]}! 🎅"

  # Send SMS
  client.messages.create(
    from: twilio_phone_num,
    to: gifter_phone_num,
    body: message
  )
  # confirm that the message was sent
  puts "SMS sent to #{gifter_name}."
end

