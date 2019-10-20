require 'net/http'
require 'json'

class Cloud
	def initialize
		@url = 'https://api.hh.ru/employers?text="Новые облачные технологии"&id=113' #area: Russia, employer: New Cloud Technologies
		@uri = URI.parse(URI.escape(@url))                                             #escaping "URI must be ascii only" issue
	end

def check_code_response
	http = Net::HTTP.new(@uri.host, @uri.port)
	http.use_ssl = true                                   #use ssl for https
	response = http.head(@uri.request_uri)
	if (response.code.to_i == 200)
		puts
		puts "Passed! Code of response is 200"
		puts "Code: #{response.code}"
	else
		puts "Fail! Code of response: #{response.code}!"
	end
end

def getting_vacancies
	response = Net::HTTP.get_response @uri
	data = JSON.parse response.body
	vacancies_url = URI.parse(data["items"][0]["vacancies_url"]+"&per_page=50")  #get vacancies url from array "items"
	unless ((data["items"][0]["vacancies_url"]+"&per_page=50") =~ /^https:\/\/api\.hh\.ru\/vacancies\?*/).nil?
		response_vacancies = Net::HTTP.get_response vacancies_url
		vacancies = JSON.parse response_vacancies.body
		puts "Found: #{vacancies["found"]}"
		puts "Vacancies:"
		puts
		vacancies["items"].each do |item|
			puts item["name"]
		end
	else
		puts "Fail! Vacancies url isn't correct!"
	end
end
end
test = Cloud.new
puts "Checking response code"
puts
test.check_code_response
puts
puts "Checking vacancies"
puts
test.getting_vacancies
