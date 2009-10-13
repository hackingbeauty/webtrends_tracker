# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => 'http://gems.github.com', :version => '2.3.1'
  config.gem 'binarylogic-authlogic', :lib => 'authlogic', :source => 'http://gems.github.com', :version => '2.1.1'
  config.gem 'haml', :version => '2.2.6'
  config.time_zone = 'UTC'
end