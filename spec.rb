#encoding: UTF-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
require 'airborne'

describe 'code of response for request /areas/1' do
  it 'should have response code 200' do
    response = get 'https://api.hh.ru/areas/1' 
    expect(response.code).to eq(200)
  end
end

describe 'check if response for request /areas/1 is empty' do
  it 'should not be empty' do
    response = get 'https://api.hh.ru/areas/1' 
    data = JSON.parse(response.body)[0]
	expect_json("id":"1","parent_id":"113")
  end
end

describe 'code of response for request https://api.hh.ru/employers?text="Новые облачные технологии"&id=113' do
  it 'should have response code 200' do
    url = 'https://api.hh.ru/employers?text="Новые облачные технологии"&id=113'
	uri = URI.parse(URI.escape(url))
	response = get uri.to_s
    expect(response.code).to eq(200)
  end
end

describe 'check if response for request https://api.hh.ru/employers?text="Новые облачные технологии"&id=113 is successful' do
  it 'should give a correct hash' do
    
	url = 'https://api.hh.ru/employers?text="Новые облачные технологии"&id=113'
	uri = URI.parse(URI.escape(url))
	response = get uri.to_s
    data = JSON.parse(response.body)["items"][0]
	expect(data["id"]).to eq("213397")
	expect(data["name"]).to eq("Новые Облачные Технологии")
	expect(data["open_vacancies"]).should_not == 0
  end
end

describe 'code of response for request https://api.hh.ru/vacancies?text="QA Automation Engineer"&area=2&employer_id=213397' do
  it 'should have response code 200' do
    url = 'https://api.hh.ru/vacancies?text="QA Automation Engineer"&area=2&employer_id=213397'
	uri = URI.parse(URI.escape(url))
	response = get uri.to_s
    expect(response.code).to eq(200)
  end
end

describe 'check if response for request https://api.hh.ru/vacancies?text="QA Automation Engineer"&area=2&employer_id=213397 is successful' do
  it 'should give a vacancy qa engineer' do
    
	url = 'https://api.hh.ru/vacancies?text="QA Automation Engineer"&area=2&employer_id=213397'
	uri = URI.parse(URI.escape(url))
	response = get uri.to_s
    data = JSON.parse(response.body)["items"][0]
	expect(data["name"]).to eq("QA Automation Engineer")
	expect(data["type"]["id"]).to eq("open")
	expect(data["employer"]["name"]).to eq("Новые Облачные Технологии")
  end
end
