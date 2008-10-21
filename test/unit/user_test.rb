require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  def test_new_user_should_be_valid
    assert create_user.valid?
  end
  
  def test_new_users_should_require_password
    assert User.new.instance_eval { password_required? }
  end
  
  def test_nil_password_should_not_require_password
    user = users(:august)
    user.password = nil
    assert !user.instance_eval { password_required? }
  end
  
  def test_empty_string_password_should_not_require_password
    user = users(:august)
    user.password = ""
    assert !user.instance_eval { password_required? }
  end
  
  def test_supplying_password_should_require_password
    user = users(:august)
    user.password = "hai"
    assert user.instance_eval { password_required? }
  end
  
  def test_succsessful_authentication
    assert_equal users(:august), User.authenticate("august", "12345")
  end

  def test_failed_authentication
    assert !User.authenticate("burger", "furger")
  end
  
  def test_generate_password_length
    range = (5..7).to_a
    
    password = User.class_eval { generate_password }
    assert range.include?(password.length)
  end
  
  def test_reset_password
    user = users(:august)
    old_password = user.password_hash.dup
    
    user.reset_password!
    new_password = user.password
    
    assert_not_equal old_password, user.password_hash
    assert User.authenticate('august', new_password)
  end
  
  def test_find_for_password_reset
    assert User.find_for_password_reset('august')
    assert User.find_for_password_reset('augustlilleaas@gmail.com')
    assert !User.find_for_password_reset('hamburger')
  end
  
  def test_valid_emails
    user = users(:august)
    %w(nissen@gmail.com super@hotmail.info alsovalid@valid.coco).each do |email|
      user.email = email
      assert user.save
    end
  end
  
  def test_invalid_emails
    user = users(:august)
    %(nissen.gmail.com nissen.gmail@com nissen@gmail failing@notvalidforreal.mururururur).each do |email|
      user.email = email
      assert !user.save
    end
  end
  
  def test_password_matching_username
    user = new_user(:username => 'matching', :password => 'matching', :password_confirmation => 'matching')
    assert !user.valid?
    assert user.errors.on(:password)
  end
  
  private
  
  def new_user(options = {})
    options.reverse_merge!(:username => "failer", :full_name => "Fail Failzer", :password => "failfail", :password_confirmation => "failfail", :email => "furgermurger@gmail.com")
    User.new(options)
  end
  
  def create_user(options = {})
    u = new_user(options)
    u.save
    u
  end
end
