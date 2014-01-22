require 'minitest/autorun'
require_relative '../lib/environment'

class GroceryTest < MiniTest::Unit::TestCase
  def database
    Environment.database_connection
  end

  def teardown
    database.execute("delete from purchases")
  end

  def assert_command_output expected, command
    actual = `#{command}`.strip
    assert_equal expected, actual
  end
end
