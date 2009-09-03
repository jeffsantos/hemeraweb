# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  layout "proof"
  
  before_filter :authorize  
  
  session :session_key => '_hemeraweb_session_id'
  
  helper :all # include all helpers, all the time'
  
  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected 
  def authorize 
    unless User.find_by_id(session[:user_id]) 
      flash[:notice] = "Please log in" 
      redirect_to :controller => :admin, :action => :login 
    end 
  end 
  
end
