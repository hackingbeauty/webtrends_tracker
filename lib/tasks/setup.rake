namespace :setup do
  
  desc "Setup Admins and Products"
  task :all => [:products, :admin]

  desc "Create default products"
  task :products => :environment do
    
    print "Creating products"
    products = [
      { :name => "ApartmentGuide",   :abbreviation => "ag",  :pivotal_project_id => 6091  },
      { :name => "RentalHouses",     :abbreviation => "rh",  :pivotal_project_id => 6703  },
      { :name => "NewHomeGuide",     :abbreviation => "nh",  :pivotal_project_id => 8834  },
      { :name => "Rentals",          :abbreviation => "rt",  :pivotal_project_id => 22353 },  
    ]
        
    products.each do |hsh|
      print "."
      Product.find_or_create_by_name(hsh)
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
