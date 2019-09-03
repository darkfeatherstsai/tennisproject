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
<<<<<<< HEAD

        unprocessed_content = doc.search('meta').to_a[12].attr('content')

        if unprocessed_content.include?("\n\n")
          content = unprocessed_content.split("\n\n")

=======
        unprocessed_content = doc.search('code')[1].children[0].content.scan(/我.+<\/p><\/div>/)[0]
        if unprocessed_content.count("p") > unprocessed_content.count("b")
          content = unprocessed_content.sub("<br />","</p>").gsub(/<\/span>|<\/a>|<\/div>|<p>|<br \/>|\s\s/,"").split("</p>")
>>>>>>> develop
        else
          content = unprocessed_content.gsub(/<\/span>|<\/a>|<\/div>|<p>|<\/p>|\s\s/,"").split("<br />")
        end
        
        racket_state = []

<<<<<<< HEAD
        if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋車機衣包顆]|back/)}[0] == nil
          a ||= Racket.new
          a.name = content.select{|element| element.match(/["名稱"]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：[物品名稱]\n")
=======
        if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋機衣包顆]|back/)}[0] == nil
          a = Racket.find_by(fb_url: racket_url)
          a ||= Racket.new
          a.name = content.select{|element| element.match(/[物品名稱]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：［[物品名稱]］\n")
>>>>>>> develop
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

<<<<<<< HEAD
          puts "nameOK========================"
=======
          racket_state << "nameOK"
>>>>>>> develop

          if content.select{|element| element.match(/\d{3}[g克]/)} != nil
            a.weight = content.select{|element| element.match(/\d{3}[gG克]/)}[0].match(/\d{3}[gG克]/)[0].delete("gG克").to_i
            racket_state << "weightOK"
          end

          if content.select{|element| element.match(/售價|元|\$/)}[0] != nil
            match_ele = content.select{|element| element.match(/售價|元|\$/)}
            match_ele.each do |ele|
              ele.delete!(",")
              a.price = ele.match(/\d{4}/)[0].to_i if ele.match?(/\d{4}/)
            end
<<<<<<< HEAD
            puts "priceOK======================="
=======

            racket_state << "priceOK"
>>>>>>> develop
          end

          if content.select{|element| element.match(/[規格]/)}[0] != nil
            a.spec = content.select{|element| element.match(/規格|拍面|握把|線床/)}.join.delete("［[產品規格]］:：\n")
            racket_state << "specOK"
          end

          if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
<<<<<<< HEAD
            a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].delete("[使用概況]:：\n")
            puts "profileOK====================="
=======
            a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].delete("［[使用概況]］:：\n")
            racket_state << "profileOK"
>>>>>>> develop
          end

          a.fb_url = racket_url
          a.lunched = 1 if racket_state.count == 5
          a.save

        else
          not_racket_url << racket_url
        end

      rescue
        error_url << racket_url
        puts $!
      end

    end

    puts "error_url====================="
    error_url.each do |url|
      puts url
    end

    puts "not_racket_url================"
    not_racket_url.each do |url|
      puts url
    end

    puts racket_urls.count

    puts error_url.count
    puts not_racket_url.count

    driver.quit
