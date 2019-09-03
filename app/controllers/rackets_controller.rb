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
    Racket.find_each do |r|
      if r.lunched == 1 && (r.name.include?(params[:keyword]) || r.label.include?(params[:keyword]))
        found_racket << r
      end
    end
    @rackets = @paginate = found_racket.paginate(:page => params[:page])
  end

  def webhook

    # 取得 reply token
    reply_token = params['events'][0]['replyToken']

    # 設定回覆訊息
    message = {
      type: 'text',
      text: "#{Racket.last}"
    }

    # 取得 reply token
    response = client.reply_message(reply_token, message)

    # 回應 200
    head :ok
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
