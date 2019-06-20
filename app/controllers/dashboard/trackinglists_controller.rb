class Dashboard::TrackinglistsController < Dashboard::DashboardController
  def show
    trackinglist = Trackinglist.find{|list| list.user_id == current_user.id}
    @rackets = Racket.find(trackinglist.racket_id)
  end

  def add
    trackinglist = Trackinglist.find{|list| list.user_id == current_user.id}
    trackinglist = Trackinglist.create(:user_id => current_user.id) if trackinglist == nil
    trackinglist.racket_id << params[:id].to_i if trackinglist.racket_id.include?(params[:id].to_i) == false
    trackinglist.save
  end

  def destroy
    trackinglist = Trackinglist.find{|list| list.user_id == current_user.id}
    trackinglist.racket_id.delete(params[:id].to_i)
    trackinglist.save
    @rackets = Racket.find(trackinglist.racket_id)
    render :show
  end
end
