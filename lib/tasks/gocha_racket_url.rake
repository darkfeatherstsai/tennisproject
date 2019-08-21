project/namespace :gocha do
  desc "A task used for gocha racket url"
  task :get_url => :environment do

    options = Selenium::WebDriver::Chrome::Options.new
    chrome_bin_path = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options.binary = chrome_bin_path if chrome_bin_path
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.navigate.to 'https://www.facebook.com/groups/468527439888685/'

    racket_urls = []
    sleep 10


    until racket_urls.size > 10
      driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
      links = driver.find_elements(:class, "_5pcq")
      links.each do |link|
        racket_urls << link.property('href')
        racket_urls.uniq!
      end
      sleep 5
    end

<<<<<<< HEAD
=======
    not_racket_url = []
>>>>>>> develop
    error_url = []

    racket_urls.each do |racket_url|
      begin
        html = open(racket_url).read

        doc = Nokogiri::HTML(html)

        unprocessed_content = doc.search('meta').to_a[12].attr('content')

<<<<<<< HEAD
        if unprocessed_content.match?(/\[/)
          content = unprocessed_content.delete("\n").split("[")
=======
        if unprocessed_content.include?("\n\n")
          content = unprocessed_content.split("\n\n")
>>>>>>> develop
        else
          content = unprocessed_content.split("\n")
        end

<<<<<<< HEAD
        #puts racket_url


        if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋車機衣包顆]|back/)}[0] == nil
          a = Racket.find_by(fb_url: racket_url)
          a ||= Racket.new
          a.name = content.select{|element| element.match(/[物品名稱]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：")
=======
        if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋車機衣包顆]|back/)}[0] == nil
          a ||= Racket.new
          a.name = content.select{|element| element.match(/["名稱"]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：[物品名稱]\n")
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
          if content.select{|element| element.match(/\d{3}[g克]/)} != nil
            a.weight = content.select{|element| element.match(/\d{3}[g克]/)}[0].match(/\d{3}/)[0].to_i
=======
          puts "nameOK========================"

          if content.select{|element| element.match(/\d{3}[g克]/)} != nil
            a.weight = content.select{|element| element.match(/\d{3}[gG克]/)}[0].match(/\d{3}[gG克]/)[0].delete("gG克").to_i
            puts "weightOK======================"
>>>>>>> develop
          end

          if content.select{|element| element.match(/售價|元|\$/)}[0] != nil
            match_ele = content.select{|element| element.match(/售價|元|\$/)}
<<<<<<< HEAD
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
=======

            match_ele.each do |ele|
              ele.delete!(",")
              a.price = ele.match(/\d{4}/)[0].to_i if ele.match?(/\d{4}/)
            end

            puts "priceOK======================="
          end

          if content.select{|element| element.match(/[規格]/)}[0] != nil
            a.spec = content.select{|element| element.match(/規格|拍面|握把|線床/)}.join.delete("[產品規格]:：")
            puts "specOK========================"
          end

          if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
            a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].delete("[使用概況]:：\n")
            puts "profileOK====================="
          end


          a.fb_url = racket_url
          a.lunched = 1 if a.name.size < 50
          a.save

        else
          not_racket_url << racket_url
>>>>>>> develop
        end

      rescue
        error_url << racket_url
        puts $!
      end

    end

<<<<<<< HEAD
=======
    puts "error_url====================="
>>>>>>> develop
    error_url.each do |url|
      puts url
    end

<<<<<<< HEAD

    driver.quit

puts "success"
=======
    puts "not_racket_url================"
    not_racket_url.each do |url|
      puts url
    end

    puts racket_urls.count
    puts error_url.count
    puts not_racket_url.count

    driver.quit

>>>>>>> develop
  end

end
