class ProfilesController < ApplicationController
  before_filter :require_login, :except => [:create]

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      # ...
    else
      # render :action => 'foo'
    end
  end

  def show
    redirect_to edit_profile_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update_attributes(params[:user])
      flash[:success] = nil
      redirect_to edit_profile_path
    else
      flash[:error] = nil
      render :action => 'edit'
    end
  end
end
