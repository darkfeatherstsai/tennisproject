class RacketsController < ApplicationController
  def index
    @racket = @paginate = Racket.paginate(:page =>params[:page])
  end
  def show
    @racket = Racket.find(paramas[:id])
  end
end
