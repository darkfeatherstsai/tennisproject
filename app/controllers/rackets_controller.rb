class RacketsController < ApplicationController
  def index
    @rackets = @paginate = Racket.paginate(:page =>params[:page])
  end

end
