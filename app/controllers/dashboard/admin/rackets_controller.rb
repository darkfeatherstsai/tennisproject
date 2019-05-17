class Dashboard::Admin::RacketsController < Dashboard::Admin::AdminController
  def index
    @rackets = @paginate = Racket.paginate(:page => params[:page])
  end
end
