class RocketsController < ApplicationController
  def index
    @rocket = @paginate = rocket.paginate(:page =>params[:page])
  end
  def show
    @rocket = Rocket.find(paramas[:id])
  end
end
