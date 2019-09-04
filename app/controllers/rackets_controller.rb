class RacketsController < ApplicationController
  protect_from_forgery with: :null_session
  require 'line/bot'

  def index
    @rackets = @paginate = Racket.paginate(:page =>params[:page])
  end

  def price_sort_decs
    @rackets = @paginate = Racket.order(price: :desc).paginate(:page => params[:page])
  end

  def price_sort_acs
    @rackets = @paginate = Racket.order(price: :asc).paginate(:page => params[:page])
  end

  def label_sort_decs
    @rackets = @paginate = Racket.order(label: :desc).paginate(:page => params[:page])
  end

  def label_sort_acs
    @rackets = @paginate = Racket.order(label: :asc).paginate(:page => params[:page])
  end

  def findracket
    found_racket = []
    Racket.where(lunched: 1).find_each do |r|
      if r.name.include?(params[:keyword]) || r.label.include?(params[:keyword])
        found_racket << r
      end
    end
    @rackets = @paginate = found_racket.paginate(:page => params[:page])
  end

  def webhook
    # 設定回覆文字
    reply_text = keyword_reply(received_text)

    # 傳送訊息到 line
    response = reply_to_line(reply_text)

    # 回應 200
    head :ok
  end

  # 取得對方說的話
  def received_text
    message = params['events'][0]['message']
    message['text'] unless message.nil?
  end

  #關鍵字回覆
  def keyword_reply(received_text)
    found_racket = []
    begin
    if received_text[0..4] == "gocha"
      racket = received_text.split(",")
      Racket.where(lunched: 1).where(weight: racket[2].to_i..racket[3].to_i).where(price: racket[4].to_i..racket[5].to_i).find_each do |r|
        if r.name.include?(racket[1]) || r.label.include?(racket[1])
          found_racket << "#{r.label} #{r.name} #{r.weight} #{r.price} #{r.fb_url}"
        end
      end
      retuen found_racket.join("\n")
    end

    #出現錯誤  
    rescue
      return "沒有符合的球拍或是格式不符"
    end

  end

  def reply_to_line(reply_text)
    # 取得 reply token
    reply_token = params['events'][0]['replyToken']

    # 設定回覆訊息
    message = {
      type: 'text',
      text: reply_text
    }

    # 傳送訊息
    line.reply_message(reply_token, message)
  end

  # Line Bot API 物件初始化
  def line
    @line ||= Line::Bot::Client.new { |config|
      config.channel_id = Rails.application.credentials.aws[:LINE_CHANNEL_ID]
      config.channel_secret = Rails.application.credentials.aws[:LINE_CHANNEL_SECRET]
      config.channel_token = Rails.application.credentials.aws[:LINE_CHANNEL_TOKEN]
    }
  end
end
