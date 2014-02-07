#!/usr/bin/env ruby
# -*- ruby -*-

require_relative 'lib/environment'

require 'rake/testtask'
Rake::TestTask.new() do |t|
  t.pattern = "test/test_*.rb"
end

desc "Run tests"
task :default => :test

desc 'import data from the given file'
task :import_data do
  Environment.environment = "production"
  require_relative 'lib/importer'
  Importer.import("data/purchase_import.csv")
end

desc 'create the production database setup'
task :bootstrap_database do
  Environment.environment = "production"
  database = Environment.database_connection
  create_tables(database)
end

desc 'prepare the test database'
task :test_prepare do
  File.delete("db/grocerytracker_test.sqlite3")
  Environment.environment = "test"
  database = Environment.database_connection
  create_tables(database)
end

def create_tables(database_connection)
  database_connection.execute("CREATE TABLE purchases (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), calories integer, price decimal(5,2), category_id integer)")
  database_connection.execute("CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
end
