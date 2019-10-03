class RacketsController < ApplicationController
  protect_from_forgery with: :null_session
  require 'line/bot'

  def index
    @q = Racket.ransack(params[:q])
    @rackets = @paginate = @q.result.paginate(:page =>params[:page])
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

  # 關鍵字回覆
  def keyword_reply(received_text)
    if received_text[0..4] == "gocha"

      # 檢查格式是否正確
      racket = received_text.split(",")
      return "格式不符" if racket.count != 6
      return find_racket_line(racket)
    end
  end

  # 搜尋符合條件的球拍
  def find_racket_line(racket)
    found_racket = []
    match_racket = Racket.where(lunched: 1).where(weight: racket[2].to_i..racket[3].to_i).where(price: racket[4].to_i..racket[5].to_i)
    if match_racket.count > 0
      match_racket.find_each do |r|
        if r.name.include?(racket[1]) || r.label.include?(racket[1])
          found_racket << "#{r.name} #{r.weight} #{r.price} #{r.fb_url}"
        end
      end
    else
      return "沒有符合的球拍"
    end

    return found_racket.join("\n")
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
