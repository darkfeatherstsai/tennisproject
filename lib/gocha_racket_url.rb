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


  if process_content[0] == nil || process_content[0].include?("買") == false
    a = Racket.new
    a.name = process_content[1]
    process_content[1].downcase!
    if process_content[1].include?("wilson")
      a.label = "wilson"
    elsif process_content[1].include?("babolat")
      a.label = "babolat"
    elsif process_content[1].include?("yonex")
      a.label = "yonex"
    elsif process_content[1].include?("head")
      a.label = "head"
    else process_content[1].include?("dunlop")
      a.label = "dunlop"
    end

    a.weight = 0
    process_content[2].split(/\D/).each do |i|
      a.weight = i.to_i if i.to_i > 250
    end

    a.price = process_content[5]
    a.spec = process_content[2]
    a.profile = process_content[3]
    a.location = process_content[4]
    a.fb_url = racket_url
    a.save
  end
end
