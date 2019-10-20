require 'net/http'
require 'json'

class Cloud
	def initialize
		
		@url = 'https://api.hh.ru/vacancies?text="QA Automation Engineer"&area=2&employer_id=213397' #area(area_id=2): St.Petersburg,
		@uri = URI.parse(URI.escape(@url))                                                           #employer: New Cloud Technologies
	end                                                                                              #escaping "URI must be ascii only" issue

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

def getting_vacancy_qa
	response = Net::HTTP.get_response @uri
	data = JSON.parse response.body
	if data["items"][0]["type"]["id"] == "open"	#get vacancy QA Automation Engineer from array "items"
		puts "Passed! Found a vacancy QA Automation Engineer!"
	else
		puts "Fail! QA Automation Engineer vacancy is not exist!"

	end
end
end
test = Cloud.new
puts "Checking response code"
puts
test.check_code_response
puts
puts "Checking vacancy QA Automation Engineer"
puts
test.getting_vacancy_qa