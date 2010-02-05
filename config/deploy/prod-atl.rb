set :rails_env, "production"


role :web, "172.22.17.101", :primary => true
role :web, "172.22.17.101"

role :app, "172.22.17.101"
           
role :db,  "172.22.17.101", :primary => true, :no_release => true
