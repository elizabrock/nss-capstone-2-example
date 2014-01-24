require_relative 'helper'
require_relative '../models/purchase'

class TestPurchase < GroceryTest
  def test_to_s_prints_details
    purchase = Purchase.new(name: "Foo", price: "1.50", calories: "10")
    expected = "Foo: 10 calories, $1.50"
    assert_equal expected, purchase.to_s
  end

  def test_all_returns_all_purchases_in_alphabetical_order
    database.execute("insert into purchases(name, calories, price) values('foo', 130, 1.50)")
    database.execute("insert into purchases(name, calories, price) values('bar', 530, 1.00)")
    results = Purchase.all
    expected = ["bar", "foo"]
    actual = results.map{ |purchase| purchase.name }
    # ^ is equivalent to:
    # actual = []
    # results.each do |purchase|
    #   actual << purchase.name
    # end
    assert_equal expected, actual
  end

  def test_all_returns_empty_array_if_no_purchases
    results = Purchase.all
    assert_equal [], results
  end
end
