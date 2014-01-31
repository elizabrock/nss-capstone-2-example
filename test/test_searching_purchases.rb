require_relative 'helper'

class TestSearchingPurchases < GroceryTest
  def test_search_returns_relevant_results
    Purchase.create(name: "Cheerios", calories: 210, price: 1.50)
    Purchase.create(name: "Corn Flakes", calories: 210, price: 1.50)
    Purchase.create(name: "Corn Bran", calories: 210, price: 1.50)

    shell_output = ""
    IO.popen('./grocerytracker search --environment test', 'r+') do |pipe|
      pipe.puts("Corn")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_in_output shell_output, "Corn Flakes", "Corn Bran"
    assert_not_in_output shell_output, "Cheerios"
  end
end
