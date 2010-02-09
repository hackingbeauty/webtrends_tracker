namespace :setup do
  desc "Create default products"
  task :products => :environment do
    
    print "Creating products"
    products = {
      "ag"  => "ApartmentGuide",
      "rh"  => "RentalHouses",
      "nh"  => "NewHomeGuide",
      "nhd" => "NewHomeDirectory"
    }
    
    products.each do |abbr, name|
      print "."
      Product.find_or_create_by_name(:name => name, :abbreviation => abbr)
    end

    puts "\nDone"
  end
end
