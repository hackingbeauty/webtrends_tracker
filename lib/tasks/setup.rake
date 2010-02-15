namespace :setup do
  
  desc "Setup Admins and Products"
  task :all => [:admin, :products]

  desc "Create default products"
  task :products => :environment do
    
    print "Creating products"
    products = {
      "ag"  => "ApartmentGuide",
      "rh"  => "RentalHouses",
      "nh"  => "NewHomeGuide",
      "nhd" => "NewHomeDirectory",
      "rt"  => "Rentals"
    }
    
    products.each do |abbr, name|
      print "."
      Product.find_or_create_by_name(:name => name, :abbreviation => abbr)
    end

    puts "\nDone"
  end

  # Add whatever fields you validate in user model
  # for me only username and password

  desc  'Setup Admin: rake setup:admin username=some_admin password=some_pass'
  task :admin => :environment do
    User.create!(:email=> "webtrends@primedia.com",  :password=> "pass", :password_confirmation => "pass")
    User.create!(:email=> "jbeckley@primedia.com",   :password=> "pass", :password_confirmation => "pass")
    User.create!(:email=> "mmuskardin@primedia.com", :password=> "pass", :password_confirmation => "pass")
  end
  
end
