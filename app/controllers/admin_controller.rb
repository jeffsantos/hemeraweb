class AdminController < ApplicationController

  before_filter :authorize, :except => [:login, :add_user]
  
  def index 
    
  end
  
  # Add a new user to the database.
  def add_user
    if request.get?
      @user = User.new
    else
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "User #{@user.name} created"
        redirect_to(:action => 'login')
      else
        flash[:notice] = "User alread exists!"
      end      
    end
  end
  
  def login 
    session[:user_id] = nil 
    if request.post? 
      user = User.authenticate(params[:name], params[:password]) 
      if user 
        session[:user_id] = user.id 
        redirect_to(:action => "index") 
      else 
        flash.now[:notice] = "Invalid user/password combination" 
      end 
    end 
  end 

  def logout 
    session[:user_id] = nil 
    flash[:notice] = "Logged out" 
    redirect_to(:controller => "proof", :action => "index") 
  end 
  
end
