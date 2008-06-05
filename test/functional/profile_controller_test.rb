require File.dirname(__FILE__) + '/../test_helper'

class ProfileControllerTest < ActionController::TestCase
  def test_show
    get_with_session :show
    assert_redirected_to edit_profile_path
  end
  
  def test_edit
    get_with_session :edit
    assert_response :success
    assert_equal users(:august), assigns(:user)
  end
  
  def test_successful_update
    post_with_session :update, :user => {:username => "newusername"}
    assert_redirected_to edit_profile_path
  end
  
  def test_failed_update
    post_with_session :update, :user => {:username => nil}
    assert !assigns(:user).valid?
    assert_response :success
  end
  
  def test_forgot_password
    get :forgot_password
    assert_response :success
  end
  
  def test_sucessfully_reset_password
    user = users(:august)
    old_password = user.password_hash.dup
    
    # Could also use .full_name or .email
    put :reset_password, :user => {:identification => user.username}
    assert_not_equal user.reload.password_hash, old_password
    assert_redirected_to forgot_password_profile_path
  end
  
  def test_failing_reset_password
    put :reset_password, :user => {:identification => 'farbl'}
    assert_response :success
    assert_template 'profile/forgot_password'
  end
end