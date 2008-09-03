class SessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  
  def new
    logged_in? ? redirect_to(root_url) : render
  end
  
  def create
    self.current_user = User.authenticate(params[:user][:username], params[:user][:password])

    if logged_in?
      redirect_to_stored_location_or_default root_url
      reset_session
    else
      flash.now[:error] = "Invalid username/password combination"
      render :action => "new"
    end
  end
  
  def destroy
    reset_session
    redirect_to root_url
  end
end
