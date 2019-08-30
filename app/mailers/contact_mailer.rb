class ContactMailer < ApplicationMailer
  def send_crawler_result(racket_urls,not_racket_url,error_url)
    @racket_urls = racket_urls
    @not_racket_url = not_racket_url
    @error_url = error_url
    mail to:Rails.application.credentials.aws[:self_mail] , subject:"爬蟲結果"
  end

  def send_scan_result(racket_urls,racket_states)
    @racket_urls = racket_urls
    @racket_states = racket_states
    mail to:Rails.application.credentials.aws[:self_mail] , subject:"掃描結果"
  end
end
