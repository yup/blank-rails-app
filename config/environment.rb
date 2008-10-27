# Be sure to restart your server when you modify this file
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

SETTINGS = YAML.load_file(File.join(Rails.root, 'config', 'settings.yml'))

Rails::Initializer.run do |config|
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.log_level = :debug
  # config.action_controller.session_store = :active_record_store
  # config.active_record.schema_format = :sql
  # config.active_record.observers = :cacher, :garbage_collector

  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => SETTINGS['cookie_key'],
    :secret      => SETTINGS['cookie_secret']
  }
end
