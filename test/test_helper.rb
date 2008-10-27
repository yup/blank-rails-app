ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all

  def logged_in?
    @controller.instance_eval { logged_in? }
  end
  
  def login_as(wut)
    @request.session[:user] = wut ? users(wut) : nil
  end
end
