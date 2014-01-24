require_relative 'helper'

class TestListingPurchases < GroceryTest
  def test_list_returns_relevant_results
    `./grocerytracker add Cheerios --calories 210 --price 1.55 --environment test`
    `./grocerytracker add "Corn Flakes" --calories 110 --price 5.50 --environment test`
    `./grocerytracker add "Corn Bran" --calories 510 --price 1.50 --environment test`

    command = "./grocerytracker list"
    expected = <<EOS.chomp
All Purchases:
Cheerios: 210 calories, $1.55
Corn Bran: 510 calories, $1.50
Corn Flakes: 110 calories, $5.50
EOS
    assert_command_output expected, command
  end
end
