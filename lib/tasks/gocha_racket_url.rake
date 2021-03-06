namespace :gocha do
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
        racket_state = [racket_url]

        html = open(racket_url).read
        doc = Nokogiri::HTML(html)
        unprocessed_content = doc.search('code')[1].children[0].content.scan(/我.+<\/p><\/div>/)[0]
        if unprocessed_content.count("p") > unprocessed_content.count("b")
          content = unprocessed_content.sub("<br />","</p>").gsub(/<\/span>|<\/a>|<\/div>|<p>|<br \/>|\s\s/,"").split("</p>")
        else
          content = unprocessed_content.gsub(/<\/span>|<\/a>|<\/div>|<p>|<\/p>|\s\s/,"").split("<br />")
        end

        if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋機衣包顆]|back/)}[0] == nil
          a = Racket.find_by(fb_url: racket_url)
          a ||= Racket.new
          a.name = content.select{|element| element.match(/["名稱"|"物品"]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：［[物品名稱]］\n")
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
          racket_state << "nameOK"

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

            racket_state << "priceOK"
          end

          if content.select{|element| element.match(/[規格]/)}[0] != nil
            spec = content.select{|element| element.match(/規格|拍面|握把|線床/)}
            if spec[0].include?("名稱") == true
              spec.slice!(0)
              a.spec = spec.join.delete("［[產品規格]］:：\n")
            else
              a.spec = spec.join.delete("［[產品規格]］:：\n")
            end
            racket_state << "specOK"
          end

          if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
            a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].delete("［[使用概況]］:：\n")
            racket_state << "profileOK"
          end

          a.fb_url = racket_url
          a.lunched = 1 if racket_state.count == 6
          a.save
          puts racket_state
          puts "====================="

        else
          not_racket_url << racket_url
        end

      rescue
        puts racket_url
        puts racket_state
        puts $!
        racket_state << $!
        error_url << racket_state
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
    ContactMailer.send_crawler_result(racket_urls,not_racket_url,error_url).deliver_now

    driver.quit
  end

end
