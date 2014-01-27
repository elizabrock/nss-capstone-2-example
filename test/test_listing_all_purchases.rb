require_relative 'helper'

class TestListingPurchases < GroceryTest
  def test_list_returns_relevant_results
    # create will be new+save
    cheerios = Purchase.create(name: "Cheerios", calories: 210, price: 1.55)
    corn_flakes = Purchase.create(name: "Corn Flakes", calories: 110, price: 5.50)
    corn_bran = Purchase.create(name: "Corn Bran", calories: 510, price: 1.50)

    command = "./grocerytracker list"
    expected = <<EOS.chomp
All Purchases:
Cheerios: 210 calories, $1.55, id: #{cheerios.id}
Corn Bran: 510 calories, $1.50, id: #{corn_bran.id}
Corn Flakes: 110 calories, $5.50, id: #{corn_flakes.id}
EOS
    assert_command_output expected, command
  end
end
