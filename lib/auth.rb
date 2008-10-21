module Auth
  def current_user
    @current_user ||= session[:user] && User.find(session[:user])
  end

  # Pass either an instance of User or nil/false here.
  def current_user=(user)
    @current_user = user
    session[:user] = user.is_a?(User) ? user.id : nil
  end
  
  def logged_in?
    current_user.is_a?(User)
  end
  
  def login_required
    restrict_access unless logged_in?
  end
  
  def restrict_access
    flash[:error] = "Action requires authentication."
    store_location
    redirect_to login_url
  end
  
  def redirect_to_stored_location_or_default(path)
    location = session[:stored_location] ? session[:stored_location].dup : path
    session[:stored_location] = nil
    redirect_to location
  end
  
  def self.included(base)
    base.helper_method :current_user, :logged_in?
  end
  
  private

  def store_location
    session[:stored_location] = request.parameters
  end
end
