# Add whatever fields you validate in user model
# for me only username and password
namespace :setup do
  desc  'Setup Admin: rake setup:admin username=some_admin password=some_pass'
  task :admin => :environment do
    User.create!(:email=> "webtrends@primedia.com",  :password=> "pass", :password_confirmation => "pass")
    User.create!(:email=> "jbeckley@primedia.com",   :password=> "pass", :password_confirmation => "pass")
    User.create!(:email=> "mmuskardin@primedia.com", :password=> "pass", :password_confirmation => "pass")
  end
end
