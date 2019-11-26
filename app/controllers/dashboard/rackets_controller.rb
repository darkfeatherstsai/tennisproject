class Dashboard::RacketsController < Dashboard::DashboardController
  def index
    @q = Racket.ransack(params[:q])
    rackets = @q.result.ransack(lunched_eq: 1)
    @rackets = @paginate = rackets.result.paginate(:page => params[:page] , :per_page => 15)
  end
end
