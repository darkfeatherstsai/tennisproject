class RacketsController < ApplicationController
  def index
    @rackets = @paginate = Racket.paginate(:page =>params[:page])
  end
  def sort_by_price
    @rackets = @paginate = Racket.order(price: desc).paginate(:page =>params[:page])
  end
end
