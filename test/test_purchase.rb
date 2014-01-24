require_relative 'helper'
require_relative '../models/purchase'

class TestPurchase < GroceryTest
  def test_to_s_prints_details
    purchase = Purchase.new(name: "Foo", price: "1.50", calories: "10")
    expected = "Foo: 10 calories, $1.50"
    assert_equal expected, purchase.to_s
  end
end
