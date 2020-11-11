require "csv"
require "google/apis/civicinfo_v2"

#Assignment: Clean Phone Numbers
#If the phone number is less than 10 digits, assume that it is a bad number
#If the phone number is 10 digits, assume that it is good
#If the phone number is 11 digits and the first number is 1, trim the 1 and use the first 10 digits
#If the phone number is 11 digits and the first number is not 1, then it is a bad number
#If the phone number is more than 11 digits, assume that it is a bad number

puts "Let's get the phone numbers!"

def clean_phone_number(phone_number)
  non_numbers = [",", "(", ")", "-", ".", " ", "+"]
  result = ""
  (phone_number.length).times do |idx|
    if non_numbers.include? phone_number[idx]
      next
    else
      result += phone_number[idx]
    end
  end

  if result.length < 10
    "Invalid Phone Number"
  elsif result.length > 10 && result[0] == "1"
    result = result[1..-1]
  elsif result.length > 10 && result[0] != "1"
    "Invalid Phone Number"
  else
    result
  end
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  # we know that the phone numbers are the 5th index
  name = row[:first_name]
  phone_number = clean_phone_number(row[:homephone])

  puts "#{name} #{phone_number}" 
end


#Let's get the phone numbers!
#6154385000 valid
#414-520-5000
#(941)979-2000
#650-799-0000
#613 565-4000 remove space and dash
#778.232.7000 remove .
#(202) 328 1000 remove paranthesis and spaces
#530-919-3000 remove dashes
#8084974000 valid
#858 405 3000 remove spaces
#14018685000 need to trim the 1, final result = 4018685000
#315.450.6000
#510 282 4000
#787-295-0000
#9.82E+00 invalid
#(603) 305-3000
#530-355-7000
#206-226-3000
#607-280-2000