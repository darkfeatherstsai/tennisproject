class Dashboard::Admin::AdminCntroller < ActionController::Base
  before_action :authenticate_manager!
end
