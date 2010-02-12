# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Rake::TaskManager.class_eval do
def remove_task(task_name)
@tasks.delete(task_name.to_s)
end
end

def remove_task(task_name)
Rake.application.remove_task(task_name)
end

remove_task 'db:schema:load'
namespace :db do
namespace :schema do
task :load do
RAILS_ENV = 'development'
Rake::Task['db:test:clone_structure'].invoke
RAILS_ENV = 'test'
end
end
end