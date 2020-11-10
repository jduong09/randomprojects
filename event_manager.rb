require "csv"
require "google/apis/civicinfo_v2"

template_letter = File.read "form_letter.html"

def clean_zipcode(zipcode)
  #if zipcode.nil?
    #zipcode = "00000"
  #elsif zipcode.length < 5
    #zipcode = zipcode.rjust 5, "0"
  #elsif zipcode.length > 5
    #zipcode = zipcode[0..4]
  #else
    #zipcode
  #end
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
                              address: zip,
                              levels: 'country',
                              roles: ['legislatorUpperBody', 'legislatorLowerBody'])    
    legislators = legislators.officials
    legislators_names = legislators.map(&:name)
    legislators_names.join(", ")
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end
puts "EventManager Initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]
  
  zip_code = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zip_code)

  personal_letter = template_letter.gsub('FIRST_NAME', name)
  personal_letter.gsub!('LEGISLATORS', legislators)

  puts personal_letter
end