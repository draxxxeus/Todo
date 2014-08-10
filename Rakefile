require 'sequel'

namespace :db do
  desc 'Migrate ToDo Database'
  task :migrate do
    Sequel.extension :migration
    DB = Sequel.connect("mysql://root:root@localhost/todo")
    DB.sql_log_level = :debug
    Sequel::Migrator.apply(DB, 'db/migrations/')
  end
end

