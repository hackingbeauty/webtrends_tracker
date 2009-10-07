namespace :setup do
  desc "Create default products"
  task :products => :environment do
    
    print "Creating products"
    products = %w(ApartmentGuide RentalHouses NewHomeGuide)
    
    products.each do |p_name|
      print "."
      Product.find_or_create_by_name(:name => p_name)
    end

    puts "\nDone"
  end
end
