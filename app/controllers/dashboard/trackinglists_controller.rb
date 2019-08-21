class Dashboard::TrackinglistsController < Dashboard::DashboardController
  before_action :set_list

  def show
  end

  def add
    @trackinglist = Trackinglist.create(:user_id => current_user.id) if @trackinglist == nil
    @trackinglist.racket_id << params[:id].to_i if @trackinglist.racket_id.include?(params[:id].to_i) == false
    @trackinglist.save
  end

  def destroy
    @trackinglist.racket_id.delete(params[:id].to_i)
    @trackinglist.save
    redirect_to :action => :index
  end

  private

  def set_list
    @trackinglist = Trackinglist.find{|list| list.user_id == current_user.id}
    @trackinglist = Trackinglist.create(:user_id => current_user.id) if @trackinglist == nil
    @rackets = Racket.find(@trackinglist.racket_id)
  end
end
