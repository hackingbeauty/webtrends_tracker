require 'mongrel_cluster/recipes'
require 'capistrano/ext/multistage'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "webtrends"
set :copy_cache, "#{ENV['HOME']}/deploy/#{application}"
set :copy_exclude, ['.git']
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :copy
set :keep_releases, 5
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"
set :repository, "git@github.com:primedia/webtrends_tracker.git"
set :scm, :git
set :stages, %w(acceptance_hashrocket qa acceptance production)
set :user, "deploy"
set :use_sudo, false

def tag_to_deploy  
  require_annotated = /refs\/tags\/(v.+\^\{\})$/ 
  all_version_tags      = `git ls-remote --tags #{repository}`.scan(require_annotated).flatten
  sorted_version_tags   = all_version_tags.sort_by{|v| v.split('.').map{|nbr| nbr[/\d+/].to_i}}
  stripped_version_tags = sorted_version_tags.map{|tag| tag.strip} 
  puts "stripped_version_tags: #{stripped_version_tags.class}"
  
  last_x_tags = []
  if stripped_version_tags.size > 10                               
    last_x_tags         = stripped_version_tags[-10..-1]
    puts "last_ten_tags: #{last_x_tags}"   
  else                                            
     max = stripped_version_tags.size
     last_x_tags         = stripped_version_tags[-max..-1]
    puts "last_ten_tags: #{last_x_tags}"
  end
  
  tag = Capistrano::CLI.ui.choose { |menu|
    menu.choices *last_x_tags
    
    menu.header    = "Available tags"
    menu.prompt    = "Tag to deploy?"
    menu.select_by = :index_or_name
  }
end

task(:set_branch) { set :branch, stage == :acceptance ? "master" : tag_to_deploy }
after 'multistage:ensure', :set_branch

after "deploy:update", "run_cfagent"

desc "Run cfagent"
	task :run_cfagent, :roles => :web do
	run "/usr/bin/sudo /usr/sbin/cfagent --no-splay -K"
end

namespace :deploy do
  desc "Perform a deploy:setup and deploy:cold"
  task :init do
    transaction do
      deploy.setup
      deploy.cold
    end
  end

  desc "Perform a code update, sanity_check, symlink and migration"
  task :full do
    transaction do
      deploy.update

      deploy.migrate

      
      deploy.stop
      sleep(3)
      deploy.start
      deploy.cleanup
    end
  end

  desc "Deploy locally"
  task :local do
    transaction do
      run "cp -R #{current_path} #{release_path}"
    end
  end

  %w(start stop restart).each do |action|
    desc "#{action} the Mongrel cluster"
    task action.to_sym do
      find_and_execute_task("mongrel:cluster:#{action}")
    end
  end
end

namespace :primedia do
  desc "Deploy public directory to proxy boxes"
  task :deploy_proxy_pages, :roles => :web, :only => { :primary => true } do
    find_servers(:roles => :proxy).each do |server|
      run "rsync -a --delete /var/www/newhomeguide.com/current/public/ #{server.host}:/var/www/newhomeguide.com/current/public"
    end
  end

  desc "Put the version that was deployed into RAILS_ROOT/VERSION"
  task :add_version_file, :roles => :web do
    run "cd #{current_path} && echo #{branch} > VERSION"
  end
end
