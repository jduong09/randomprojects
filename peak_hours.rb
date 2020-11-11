require "csv"
require "google/apis/civicinfo_v2"
require "date"

puts "Let's find out what peak registration hours are!"

def clean_date_and_time(date_time)
  DateTime.strptime(date_time, '%m/%d/%y %H:%M')
end


contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
hours = Hash.new(0)
contents.each do |row|
  date_and_time = clean_date_and_time(row[:regdate])
  hours[date_and_time.hour] += 1
 
end
sorted = hours.sort_by { |k, v| v }

puts sorted