require 'minitest/autorun'

class GroceryTest < MiniTest::Unit::TestCase
  def database
    # memoization
    @database ||= SQLite3::Database.new("grocerytracker_test")
  end

  def teardown
    database.execute("delete from purchases")
  end

  def assert_command_output expected, command
    actual = `#{command}`.strip
    assert_equal expected, actual
  end
end
