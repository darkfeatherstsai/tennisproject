require 'open-uri'
require 'nokogiri'


html = open('https://www.facebook.com/groups/468527439888685/permalink/3035474786527258/').read

doc = Nokogiri::HTML(html)
unprocessed_content = doc.search('code')[1].children[0].content.scan(/我.+<\/p><\/div>/)[0]

begin

if unprocessed_content.count("p") > unprocessed_content.count("b")
  content = unprocessed_content.sub("<br />","</p>").gsub(/<\/span>|<\/a>|<\/div>|<p>|<br \/>|\s\s/,"").split("</p>")
else
  content = unprocessed_content.gsub(/<\/span>|<\/a>|<\/div>|<p>|<\/p>|\s\s/,"").split("<br />")
end

  if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋機衣包顆]|back/)}[0] == nil
    a ||= Racket.new
    a.name = content.select{|element| element.match(/["名稱"]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：［[物品名稱]］\n")
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

    puts "nameOK========================"

    if content.select{|element| element.match(/\d{3}[g克]/)} != nil
      a.weight = content.select{|element| element.match(/\d{3}[gG克]/)}[0].match(/\d{3}[gG克]/)[0].delete("gG克").to_i
      puts "weightOK======================"
    end

    if content.select{|element| element.match(/售價|元|\$/)}[0] != nil
      match_ele = content.select{|element| element.match(/售價|元|\$/)}

      match_ele.each do |ele|
        ele.delete!(",")
        a.price = ele.match(/\d{4}/)[0].to_i if ele.match?(/\d{4}/)
      end

      puts "priceOK======================="
    end

    if content.select{|element| element.match(/[規格]/)}[0] != nil
      a.spec = content.select{|element| element.match(/規格|拍面|握把|線床/)}.join.delete("［[產品規格]］:：\n")
      puts "specOK========================"
    end

    if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
      a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].delete("［[使用概況]］:：\n")
      puts "profileOK====================="
    end

    a.lunched = 1 if a.name.size < 50
    a.save
    puts a
  end

rescue
  puts $!
end
