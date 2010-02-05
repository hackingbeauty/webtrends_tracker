set :rails_env, "acceptance"

role  :proxy,     "10.130.87.50", :no_release => true
role  :app,       "10.130.87.73"
role  :web,       "10.130.87.73", :primary => true
role  :db,        "10.130.87.73", :primary => true, :no_release => true
