require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_validity_of_new_user
    assert new_user.valid?
  end

  def test_password_confirmation_required_on_create
    u = new_user
    u.password_confirmation = nil
    assert !u.valid?

    u.password_confirmation = ""
    assert !u.valid?

    u.password_confirmation = '12345'
    assert u.valid?
  end

  def test_password_confirmation_required_when_updating_password
    u = users(:leethal)

    u.password = "yarr"
    u.password_confirmation = ""
    assert !u.valid?

    u.password_confirmation = "nada"
    assert !u.valid?

    u.password_confirmation = "yarr"
    assert u.valid?
  end

  def test_password_required
    u = new_user
    assert u.instance_eval { password_required? }
    
    u = users(:leethal)
    u.password = ""
    assert !u.instance_eval { password_required? }
    
    u.password = "not blank"
    assert u.instance_eval { password_required? }
  end

  def test_setting_hash_and_salt_when_creating
    u = new_user

    assert_nil u.password_hash
    assert_nil u.password_salt

    u.save

    assert u.password_hash.is_a?(String)
    assert u.password_salt.is_a?(String)
  end

  def test_rehashing_passwword_when_updating
    u = users(:leethal)

    old_hash = u.password_hash.dup
    old_salt = u.password_salt.dup

    u.password = "98765"
    u.password_confirmation = "98765"
    u.save

    assert_not_equal old_hash, u.password_hash
    assert_not_equal old_salt, u.password_salt
  end

  def test_successful_authentication
    assert User.authenticate('augustlilleaas@gmail.com', '12345')
  end

  def test_failing_authentication
    assert !User.authenticate('augustlilleaas@gmail.com', '')
    assert !User.authenticate('augustlilleaas@gmail.com', '98765')
    assert !User.authenticate('noone', 'foobar')
    assert !User.authenticate('noone', '12345')
  end

  def test_valid_emails
    %(foo@bar.com bubububub@bubububub.bubububub).each do |email|
      assert new_user(:email => email).valid?
    end
  end

  def test_invalid_emails
    %w(foo@bar kazakaz.muz.faz burgerfurger).each do |email|
      assert !new_user(:email => email).valid?
    end
  end

  private

  def new_user(attributes = {})
    attributes.reverse_merge!(:email => 'santa@northpole.com', :password => '12345', :password_confirmation => '12345')
    User.new(attributes)
  end
end
