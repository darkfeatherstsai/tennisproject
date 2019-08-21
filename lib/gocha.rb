require 'open-uri'
require 'nokogiri'

<<<<<<< HEAD
html = open('https://www.facebook.com/groups/468527439888685/permalink/3026400194101384/').read
=======
html = open('https://www.facebook.com/groups/468527439888685/permalink/3013977675343636/').read
>>>>>>> develop

doc = Nokogiri::HTML(html)

unprocessed_content = doc.search('meta').to_a[12].attr('content')

if unprocessed_content.include?("\n\n")
  content = unprocessed_content.split("\n\n")
else
  content = unprocessed_content.split("\n")
end



begin

  if content.first.match?("賣") && content.select{|element| element.match(/日本|[裝鞋車機衣包顆]|back/)}[0] == nil
    a ||= Racket.new
    a.name = content.select{|element| element.match(/["名稱"]/)}[0].split(/[:：\}\s]/ , 2)[1].delete(":：[物品名稱]\n")
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
      a.weight = content.select{|element| element.match(/\d{3}[gG克]/)}[0].match(/\d{3}/)[0].to_i
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
      a.price = match_ele.select{|element| element.match(/\d{4}/)}[0].match(/\d{4}/)[0].to_i
=======

      match_ele.each do |ele|
        ele.delete!(",")
        a.price = ele.match(/\d{4}/)[0].to_i if ele.match?(/\d{4}/)
      end

      puts "priceOK======================="
>>>>>>> develop
    end

    if content.select{|element| element.match(/[規格]/)}[0] != nil
      a.spec = content.select{|element| element.match(/規格|拍面|握把|線床/)}.join.delete("[產品規格]:：")
<<<<<<< HEAD
    end

    if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
      a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].split(/[:：]/)[1].delete("\n")
=======
      puts "specOK========================"
    end

    if content.select{|element| element.match(/使用|概況|狀態/)}[0] != nil
      a.profile = content.select{|element| element.match(/使用|概況|狀態/)}[0].delete("[使用概況]:：\n")
      puts "profileOK====================="
>>>>>>> develop
    end
    a.save
    puts a
  end

rescue
  puts $!
end
