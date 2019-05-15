class RocketsController < ApplicationController
  def index
    @rocket = @paginate = Rocket.paginate(:page =>params[:page])
  end
  def show
    @rocket = Rocket.find(paramas[:id])
  end
end
