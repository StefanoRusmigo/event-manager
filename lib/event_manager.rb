require "csv"
require "sunlight/congress"
require "erb"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode (zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]

end

def legislators_by_zipcode zipcode
	legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)

end

def save_letters (form_letter, id)
	Dir.mkdir("Personalized_Letters") unless Dir.exists? "Personalized_Letters"

	filename = "letter_id##{id}.html"
	File.open("Personalized_Letters/#{filename}",'w') do |file|
		file.puts form_letter
	end

end
template_letter = File.read "form.erb"
erb_template = ERB.new template_letter

puts "Welcome to event manager"

events = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

events.each do |file|
	id = file[0]
	name = file[:first_name]

	zipcode = clean_zipcode(file[:zipcode])

	legislators_name = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)
  save_letters(form_letter,id)
	
	
end