class Dashboard::Admin::AdminController < ActionController::Base
  before_action :authenticate_manager!
  layout "admin"
end
