# A module, included into the application controller, containing all the
# authentication methods.
module Authentication
  def self.included(base)
    base.helper_method :logged_in?, :current_user
  end
  
  private

  def current_user
    @current_user ||= session[:user] && User.find(session[:user])
  end

  def current_user=(user)
    @current_user = user
    session[:user] = user.is_a?(User) ? user.id : nil
  end

  def logged_in?
    current_user.is_a?(User)
  end

  def require_login
    restrict_access unless logged_in?
  end

  def restrict_access
    flash[:error] = "You have to log in or create a user before you do that!"
    redirect_to root_path
  end
end
