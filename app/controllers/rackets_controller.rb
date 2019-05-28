class RacketsController < ApplicationController
  def index
    @rackets = @paginate = Racket.paginate(:page =>params[:page])
  end
  def show
    @rackets = Racket.find(paramas[:id])
  end
end
