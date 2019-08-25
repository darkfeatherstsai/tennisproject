namespace :scan do
  desc "A task used for scan all racket url in the Racket"
  task :url => :environment do
    racket_urls = Racket.where(lunched: 1)
    racket_states = []
    racket_urls.each do |racket|
      begin
      a = racket
      url = racket.fb_url
      html = open(url).read
      doc = Nokogiri::HTML(html)
      unprocessed_content = doc.search('code')[1].children[0].content.scan(/我.+<\/p><\/div>/)[0]
      if unprocessed_content.count("p") > unprocessed_content.count("b")
        content = unprocessed_content.sub("<br />","</p>").gsub(/<\/span>|<\/a>|<\/div>|<p>|<br \/>|\s\s/,"").split("</p>")
      else
        content = unprocessed_content.gsub(/<\/span>|<\/a>|<\/div>|<p>|<\/p>|\s\s/,"").split("<br />")
      end

      state = []

      if content.include?("售出")
        a.name = "[售出] #{a.name}"
        a.lunched = 2
        state << "已售出"
      end

      if content.select{|element| element.match(/售價|元|\$/)}[0] != nil
        match_ele = content.select{|element| element.match(/售價|元|\$/)}
        new_price = a.price
        match_ele.each do |ele|
          ele.delete!(",")
          new_price = ele.match(/\d{4}/)[0].to_i if ele.match?(/\d{4}/)
        end

        if a.price != new_price
          state << "price is changed"
          a.price = new_price
        end

      end

      a.save
      puts "still onsale , price doesn't change"
      puts "====================="

      rescue
        puts $!
        puts url

        if unprocessed_content == nil
          a.lunched = 2
          a.name = "[售出]#{a.name}"
          a.save
          state << "已售出"
        end

      end

      if state.count != 0
        state << url
        racket_states << state
      end

    end

    racket_urls = Racket.all
    ContactMailer.send_scan_result(racket_urls,racket_states).deliver_now

  end
end
