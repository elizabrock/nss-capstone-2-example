require_relative 'helper'
require 'sqlite3'

class TestSearchingPurchases < GroceryTest
  def test_search_returns_relevant_results
    `./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test`
    `./grocerytracker add "Corn Flakes" --calories 210 --price 1.50 --environment test`
    `./grocerytracker add "Corn Bran" --calories 210 --price 1.50 --environment test`

    shell_output = ""
    IO.popen('./grocerytracker search', 'r+') do |pipe|
      pipe.puts("Corn")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_in_output shell_output, "Corn Flakes", "Corn Bran"
    assert_not_in_output shell_output, "Cheerios"
  end
end
