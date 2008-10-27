require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def test_successful_create
    flunk "Test creation of profile"
    assert_difference('User.count') do
      post :create, :user => {:email => 'foo@bar.com', :password => '12345', :password_confirmation => '12345'}
    end
    
    assert logged_in?
    # ...
  end

  def test_failed_create
    flunk "Test failed creation of profile"
    assert_no_difference('User.count') do
      post :create, :user => {:email => 'silly'}
    end

    assert !logged_in?
    assert_response :success
  end

  def test_showing_redirects_to_edit
    login_as :leethal
    get :show
    assert_redirected_to edit_profile_path
  end

  def test_edit
    login_as :leethal
    get :edit
    assert_response :success
  end

  def test_successful_update
    login_as :leethal
    post :update, :user => {:email => 'new@email.com'}
    assert_equal 'new@email.com', assigns(:user).email
    assert_redirected_to edit_profile_path
  end

  def test_failed_update
    login_as :leethal
    post :update, :user => {:email => nil}

    assert_response :success
    assert_template 'profiles/edit'
  end
end
