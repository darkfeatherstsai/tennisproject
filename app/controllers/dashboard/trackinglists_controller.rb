class Dashboard::TrackinglistsController < Dashboard::DashboardController
  def index
    @rackets = @paginate = Racket.paginate(:page => params[:page])
  end
  def add
    trackinglist = Trackinglist.find{|list| list.user_id == current_user.id}
    trackinglist = Trackinglist.create(:user_id => current_user.id) if trackinglist == nil
    trackinglist.racket_id << params[:id].to_i if trackinglist.racket_id.include?(params[:id].to_i) == false
    trackinglist.save
  end
end
