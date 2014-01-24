#!/usr/bin/env ruby
# -*- ruby -*-

require_relative 'lib/environment'
require 'rake/testtask'
Rake::TestTask.new() do |t|
  t.pattern = "test/test_*.rb"
end

desc "Run tests"
task :default => :test

desc 'create the production database setup'
task :bootstrap_database do
  database = Environment.database_connection("production")
  create_tables(database)
end

desc 'prepare the test database'
task :test_prepare do
  File.delete("db/grocerytracker_test.sqlite3")
  database = Environment.database_connection("test")
  create_tables(database)
end

def create_tables(database_connection)
  database_connection.execute("CREATE TABLE purchases (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), calories integer, price decimal(5,2))")
end
