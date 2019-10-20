#encoding: cp866
require 'net/http'
require 'json'

class Test
	def initialize
		@url = URI('https://api.hh.ru')
		@response = nil
	end	
def check_resp_code rel_path                              #check the code of response
	http = Net::HTTP.new(@url.host, @url.port)
	http.use_ssl = true                                   #use ssl for https
	@response = http.head(rel_path)
	if (@response.code.to_i == 200)
		puts
		puts "Passed! Code of response is 200"
		puts "Code: #{@response.code}"
	else
		puts "Fail! Code of response: #{@response.code}!"
	end
end

def check_empty_response rel_path
	@response = Net::HTTP.get_response (@url + rel_path)
	@data = JSON.parse @response.body                      #parse response body to array of hashes: [{..},..{..}]
	empty = false
	@data.each do |item|
		if item.empty?                                     # check each hash in array if it empty. Main array has 9 hashes: [0..8] 
			puts "Fail! Empty item of array! Index:#{@data.index(item)}"
			empty = true
		end
	 end
	 if !empty
		puts "Passed! Response isn't empty!"
	 end
end

def check_correct_body rel_path
	@response = Net::HTTP.get_response (@url + rel_path)      #initiate connect
	@data = JSON.parse @response.body                         #parsing to array of hashes
	if rel_path == "/areas"                                   #if request of all areas 
		puts "Countries:"                                     #print all countries
		@data.each do |item|
			puts item["name"]
		end
	elsif @data["areas"].empty?                               #if requesting one area of some country
		puts "Area:"
		puts @data["name"]                                    #print it area
	elsif !@data["areas"].empty?                              #if requesting some country
		puts "Country: #{@data["name"]}"                      #print name of country
		puts "Areas:"
		@data["areas"].each do |area|                         #and areas of that country
			puts area["name"]
		end
	end
end
end
print 'Enter relative path (after hh.ru) you want to test: '
path = gets.chomp
puts
puts "Please, choose the test:"
puts "1. Check status code"
puts "2. Check if response is empty"
puts "3. Check if the body of response is correct"

puts
print "Enter a number of test you want to start: "

while 1 do
	test_number = gets.chomp.to_i
	puts
	case test_number
		when 1..3
			case test_number
				when 1
					test = Test.new
					test.check_resp_code path
					break
				when 2
					test = Test.new
					test.check_empty_response path
					break
				when 3
				test = Test.new
				test.check_correct_body path
				break
			end
		else 
			print "That test is not exist! Enter the correct number: "

	end
	
end