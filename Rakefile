#!/usr/bin/env ruby
# -*- ruby -*-

require_relative 'lib/environment'
require 'rake/testtask'
Rake::TestTask.new() do |t|
  t.pattern = "test/test_*.rb"
end

desc "Run tests"
task :default => :test

task :bootstrap_database do
  require 'sqlite3'
  database = Environment.database_connection("production")
  database.execute("CREATE TABLE purchases (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), calories integer, price decimal(5,2))")
end

task :test_prepare do
  require 'sqlite3'
  File.delete("db/grocerytracker_test.sqlite3")
  database = Environment.database_connection("test")
  database.execute("CREATE TABLE purchases (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), calories integer, price decimal(5,2))")
end
