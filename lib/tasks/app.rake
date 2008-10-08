require "fileutils"
require "yaml"
require "digest/sha1"

namespace :app do
  desc 'Creates a database.yml and settings.yml.'
  # Because the salt format is and should be different from every app, this rake tasks
  # generates it and also creates a working users.yml fixture.
  task :init do
    puts ">> Creating database.yml.."
    FileUtils.cp(File.join(Rails.root, 'config', 'database.sample.yml'), File.join(Rails.root, 'config', 'database.yml'))
    
    puts ">> Creating settings.yml.."
    
    create_settings_dot_yml
    
    puts '>> Creating users fixture with "12345" as password..'
    create_user_fixture
    
    puts ">> Migrating the database.."
    Rake::Task["db:migrate"].invoke
  end
  
  def create_settings_dot_yml
    settings = {}
    
    settings["cookie_key"] = get_cookie_key
    settings["cookie_secret"] = generate_secret
    settings["system_message"] = ""
    @salt_format = generate_salt_format
    settings["salt_format"] = @salt_format
    
    yamlize_and_save(settings, File.join(Rails.root, 'config', 'settings.yml'))
  end
  
  def create_user_fixture
    salt = generate_salt
    password_hash = Digest::SHA1.hexdigest(@salt_format % ['12345', salt])
    
    data = {
      'august' => {
        'username' => 'august',
        'email' => 'augustlilleaas@gmail.com',
        'full_name' => 'August Lilleaas',
        'password_hash' => password_hash,
        'password_salt' => salt,
      }
    }
    
    yamlize_and_save(data, File.join(Rails.root, 'test', 'fixtures', 'users.yml'))
  end
  
  def generate_salt_format
    secret = generate_secret
    2.times { secret.insert(rand(secret.length), "%s") }
    
    return secret
  end
  
  def generate_secret
    %x{rake secret}.split("\n")[1]
  end
  
  def generate_salt
    generate_secret[1..40]
  end
  
  def get_cookie_key
    ENV['SESSION_COOKIE_NAME'] || begin
        puts "  Using _myapp_session as session cookie name. You probably want to change that. You can also set it with the SESSION_COOKIE_NAME environment variable (rake app:init SESSION_COOKIE_NAME='_myapp_session')"
      '_myapp_session'
    end
  end
  
  def yamlize_and_save(data_hash, target)
    File.delete(target) if File.file?(target)
    File.open(target, "w+") {|f| f.puts YAML.dump(data_hash) }
  end
end