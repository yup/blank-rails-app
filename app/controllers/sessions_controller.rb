class SessionsController < ApplicationController
  before_filter :require_login, :except => [:new, :create]

  def new
    render
  end

  def create
    self.current_user = User.authenticate(params[:user][:email], params[:user][:password])

    if logged_in?
      # ...
    else
      flash.now[:error]
      # Persisting the email in the form
      @user = User.new(:email => params[:user][:email])
      # ...
    end
  end

  def destroy
    self.current_user = nil
    reset_session
    redirect_to root_path
  end
end
