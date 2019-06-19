require "selenium-webdriver"
require 'open-uri'
require 'nokogiri'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'https://www.facebook.com/groups/468527439888685/'

racket_urls = []

until racket_urls.size > 200
  driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
  links = driver.find_elements(:class, "_5pcq")
  links.each do |link|
    racket_urls << link.property('href')
    racket_urls.uniq!
  end
  sleep 5
end

error_url = []

racket_urls.each do |racket_url|
  html = open(racket_url).read

  doc = Nokogiri::HTML(html)

  unprocessed_content = doc.search('meta').to_a[12].attr('content')

  if unprocessed_content.match?(/\[/)
    content = unprocessed_content.delete("\n").split("[")
  else
    content = unprocessed_content.split("\n")
  end

  puts racket_url

begin
  if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋車機衣包顆]|back/)}[0] == nil
    a = Racket.find_by(fb_url: racket_url)
    a ||= Racket.new
    a.name = content.select{|element| element.match(/[物品名稱]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：")
    a.name.downcase!
    if a.name.include?("wil")
      a.label = "wilson"
    elsif a.name.include?("bab")
      a.label = "babolat"
    elsif a.name.include?("yon")
      a.label = "yonex"
    elsif a.name.include?("he")
      a.label = "head"
    elsif a.name.include?("pri")
      a.label = "prince"
    elsif a.name.include?("dun")
      a.label = "dunlop"
    elsif a.name.include?("vol")
      a.label = "volkl"
    else
      a.label = "其他"
    end

    a.weight = content.select{|element| element.match(/\d{3}[g克]/)}[0].match(/\d{3}/)[0].to_i if content.select{|element| element.match(/\d{3}[g克]/)}[0].match(/\d{3}/)[0] != nil
    a.price = content.select{|element| element.match(/售價|元|\$/)}[0].match(/\d{4}/)[0] if content.select{|element| element.match(/售價|元|\$/)}[0] != nil
    a.spec = content.select{|element| element.match(/[規格]/)}[0].delete("產品規格：:]") if content.select{|element| element.match(/[規格]/)}[0] != nil
    a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].split(/[:：\s]/)[1] if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
    a.fb_url = racket_url
    a.lunched = 1 if a.name.size < 50
    a.save
  end

rescue
  error_url << racket_url
  puts "失敗"
end

end

error_url.each do |url|
   puts url
end
