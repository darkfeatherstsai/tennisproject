class Dashboard::TrackinglistsController < Dashboard::DashboardController
  def index
    @rackets = @paginate = Racket.paginate(:page => params[:page])
  end
end
