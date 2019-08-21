require "selenium-webdriver"
require 'open-uri'
require 'nokogiri'

    options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])

    driver = Selenium::WebDriver.for(:firefox, options: options)
    driver.get('https://www.facebook.com/groups/468527439888685/')

    racket_urls = []

    until racket_urls.size > 50
      driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
      links = driver.find_elements(:class, "_5pcq")
      links.each do |link|
        racket_urls << link.property('href')
        racket_urls.uniq!
      end
      sleep 5
    end

    not_racket_url = []
    error_url = []

    racket_urls.each do |racket_url|
      begin
        html = open(racket_url).read

        doc = Nokogiri::HTML(html)

        unprocessed_content = doc.search('meta').to_a[12].attr('content')

        if unprocessed_content.match?(/\[/)
          content = unprocessed_content.delete("\n").split("[")
        else
          content = unprocessed_content.split("\n")
        end

        if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋車機衣包顆]|back/)}[0] == nil
          a = Racket.find_by(fb_url: racket_url)
          a ||= Racket.new
          a.name = content.select{|element| element.match(/[物品名稱]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：")
          a.name.downcase!
          if a.name.match?("wil")
            a.label = "wilson"
          elsif a.name.match?("bab")
            a.label = "babolat"
          elsif a.name.match?(/yon|yy/)
            a.label = "yonex"
          elsif a.name.match?("he")
            a.label = "head"
          elsif a.name.match?("pri")
            a.label = "prince"
          elsif a.name.match?("dun")
            a.label = "dunlop"
          elsif a.name.match?("vol")
            a.label = "volkl"
          elsif a.name.match?("tecn")
            a.label = "tecnifibre"
          else
            a.label = "其他"
          end

          if content.select{|element| element.match(/\d{3}[g克]/)} != nil
            a.weight = content.select{|element| element.match(/\d{3}[g克]/)}[0].match(/\d{3}/)[0].to_i
          end

          if content.select{|element| element.match(/售價|元|\$/)}[0] != nil
            match_ele = content.select{|element| element.match(/售價|元|\$/)}
            a.price = match_ele.select{|element| element.match(/\d{4}/)}[0].match(/\d{4}/)[0]
          end

          if content.select{|element| element.match(/[規格]/)}[0] != nil
            a.spec = content.select{|element| element.match(/規格|拍面|握把|線床/)}.join.delete("產品規格]").slice(1..-1)
          end

          if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
            a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].split(/[:：\s]/)[1]
          end

          a.fb_url = racket_url
          a.lunched = 1 if a.name.size < 50
          a.save

        else
          not_racket_url << racket_url
        end

      rescue
        error_url << racket_url
        puts $!
      end

    end

    error_url.each do |url|
      puts url
    end

    puts error_url.count
    puts not_racket_url.count

    driver.quit
