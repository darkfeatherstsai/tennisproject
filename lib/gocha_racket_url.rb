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

  content = doc.search('meta').to_a[12].attr('content').split("\n")
  content.delete("")

  puts racket_url

  if content[0].match?(/[買]/) == false && content[1].match?(/[鞋車日本袋]|back/) == false
    a = Racket.new
    a.name = content.select{|element| element.match(/[物品名稱]/)}[0].split(/[:：\}\]]/)[1]
    a.name.downcase!
    if a.name.include?("wil")
      a.label = "wilson"
    elsif a.name.include?("bab")
      a.label = "babolat"
    elsif a.name.include?("yon")
      a.label = "yonex"
    elsif a.name.include?("he")
      a.label = "head"
    else a.name.include?("dun")
      a.label = "dunlop"
    end

    a.weight = content.select{|element| element.match(/[2-90]{3}/)}[0].match(/\d{3}/)[0]
    a.price = content.select{|element| element.match(/售價|元/)}[0].match(/\d{4}/)[0]
    a.spec = content.select{|element| element.match(/[規格]/)}[0]
    a.profile = content.select{|element| element.match(/[使用概況狀態]/)}[0].split(/[:：]/)[1] if content.select{|element| element.match(/[使用概況狀態]/)}[0] != nil
    a.fb_url = racket_url
    a.save
  end
end
