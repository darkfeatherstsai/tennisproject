require "selenium-webdriver"
require 'open-uri'
require 'nokogiri'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'https://www.facebook.com/groups/468527439888685/'

links = driver.find_elements(:class, "_5pcq")

racket_urls = []

links.each do |link|
  racket_urls << link.property('href')
end

racket_urls.each do |racket_url|
  html = open(racket_url).read

  doc = Nokogiri::HTML(html)

  content = doc.search('meta').to_a[12].attr('content')

  process_content = []
  content_index = 0

  content.delete!("\n").split("[").each do |element|
    process_content << element.split("：")[content_index]
    content_index += 1 if content_index < 1
  end


  if process_content[0].include("賣") == true
    a = Racket.new
    a.name = process_content[1]

    case process_content[1].downcase!
    when process_content[1].include?("wilson")
      a.label = "wilson"
    when process_content[1].include?("babolat")
      a.label = "babolat"
    when process_content[1].include?("yonex")
      a.label = "yonex"
    when process_content[1].include?("head")
      a.label = "head"
    when process_content[1].include?("dunlop")
      a.label = "dunlop"
    end

    a.weight = process_content[2]
    a.price = process_content[5]
    a.spec = process_content[2]
    a.profile = process_content[3]
    a.location = process_content[4]
    a.fb_url = racket_url
    a.save
  end
end
