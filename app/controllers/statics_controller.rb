class StaticsController < ApplicationController
  def index
    @rocket = @paginate = Rocket.paginate(:page =>params[:page])
  end
end
