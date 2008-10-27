require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_successful_login
    flunk "Test redirection after successful login."
    post :create, :user => {:email => 'augustlilleaas@gmail.com', :password => '12345'}
    assert logged_in?
    assert_equal users(:leethal).id, @request.session[:user]
  end

  def test_failed_login
    flunk "Test failed login"
    post :create, :user => {:email => 'silly'}
    assert !logged_in?
    assert_response :success
  end

  def test_logout
    login_as :leethal
    post :destroy

    assert_redirected_to root_path
    assert !logged_in?
  end
end
