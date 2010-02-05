set :rails_env, "qa"

role  :app,       "10.130.86.22"
role  :web,       "10.130.86.22" :primary => true
role  :db,        "10.130.86.22", :primary => true, :no_release => true
