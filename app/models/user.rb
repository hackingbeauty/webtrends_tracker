class User < ActiveRecord::Base
  
  acts_as_authentic do |config|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    # config.my_config_option = my_value 
  end
      
  
end
