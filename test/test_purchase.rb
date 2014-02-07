require_relative 'helper'

class TestPurchase < GroceryTest
  def test_count_when_no_purchases
    assert_equal 0, Purchase.count
  end

  def test_count_of_multiple_purchases
    Purchase.create(name: "foo", calories: 130, price: 1.50)
    Purchase.create(name: "Corn", calories: 530, price: 1.00)
    Purchase.create(name: "Cornflakes", calories: 530, price: 1.00)
    assert_equal 3, Purchase.count
  end

  def test_category_defaults_to_unknown
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10")
    assert_equal "Unknown", purchase.category.name
  end

  def test_to_s_prints_details
    purchase = Purchase.new(name: "Foo", price: "1.50", calories: "10")
    expected = "Foo: 10 calories, $1.50, id: #{purchase.id}"
    assert_equal expected, purchase.to_s
  end

  def test_update_doesnt_insert_new_row
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10")
    foos_before = Purchase.count
    purchase.update(name: "Bar")
    foos_after = Purchase.count
    assert_equal foos_before, foos_after
  end

  def test_update_saves_to_the_database
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10")
    id = purchase.id
    purchase.update(name: "Bar", price: "2.50", calories: "20")
    updated_purchase = Purchase.find(id)
    expected = ["Bar", 2.50, 20 ]
    actual = [ updated_purchase.name, updated_purchase.price, updated_purchase.calories]
    assert_equal expected, actual
  end

  def test_update_is_reflected_in_existing_instance
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10")
    purchase.update(name: "Bar", price: "2.50", calories: "20")
    expected = ["Bar", 2.50, 20 ]
    actual = [ purchase.name, purchase.price, purchase.calories]
    assert_equal expected, actual
  end

  def test_saved_purchases_are_saved
    purchase = Purchase.new(name: "Foo", price: "1.50", calories: "10")
    foos_before = Purchase.count
    purchase.save
    foos_after = Purchase.count
    assert_equal foos_before + 1, foos_after
  end

  def test_save_creates_an_id
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10")
    refute_nil purchase.id, "Purchase id shouldn't be nil"
  end

  def test_save_saves_category_id
    category = Category.find_or_create_by(name: "Meats")
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
    category_id = Purchase.find(purchase.id).category.id
    assert_equal category.id, category_id, "Category.id and purchase.category_id should be the same"
  end

  def test_save_update_category_id
    category1 = Category.find_or_create_by(name: "Meats")
    category2 = Category.find_or_create_by(name: "Veggies")
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category1)
    purchase.category = category2
    purchase.save
    category_id = Purchase.find(purchase.id).category.id
    assert_equal category2.id, category_id, "Category2.id and purchase.category_id should be the same"
  end

  def test_find_returns_the_row_as_purchase_object
    category = Category.find_or_create_by(name: "Things")
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
    found = Purchase.find(purchase.id)
    # Ideally: assert_equal purchase, found
    # Hacky way so that we can focus on today's material:
    assert_equal purchase.name, found.name
    assert_equal purchase.id, found.id
    assert_equal purchase.calories, found.calories
    assert_equal purchase.price, found.price
  end

  def test_find_returns_the_purchase_with_correct_category
    category = Category.find_or_create_by(name: "Things")
    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
    found = Purchase.find(purchase.id)
    refute_equal Category.default.id, found.category.id
    assert_equal category.id, found.category.id
  end

  def test_search_returns_purchase_objects
    Purchase.create(name: "foo", calories: 130, price: 1.50)
    Purchase.create(name: "Corn", calories: 530, price: 1.00)
    Purchase.create(name: "Cornflakes", calories: 530, price: 1.00)
    results = Purchase.search("Corn")
    assert results.all?{ |result| result.is_a? Purchase }, "Not all results were Purchases"
  end

  def test_search_returns_appropriate_results
    purchase1 = Purchase.create(name: "foo", calories: 130, price: 1)
    purchase2 = Purchase.create(name: "Corn", calories: 530, price: 1)
    purchase3 = Purchase.create(name: "Cornflakes", calories: 530, price: 1)

    expected = [purchase2, purchase3]
    actual = Purchase.search("Corn")

    assert_equal expected, actual
  end

  def test_search_returns_empty_array_if_no_results
    Purchase.create(name: "foo", calories: 130, price: 1.50)
    Purchase.create(name: "Corn", calories: 530, price: 1.00)
    Purchase.create(name: "Cornflakes", calories: 530, price: 1.00)
    results = Purchase.search("Soda")
    assert_equal [], results
  end

  def test_all_returns_all_purchases_in_alphabetical_order
    Purchase.create(name: "foo", calories: 130, price: 1.50)
    Purchase.create(name: "bar", calories: 530, price: 1.00)
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

  def test_equality_on_same_object
    purchase = Purchase.create(name: "foo", calories: 130, price: 1.50)
    assert purchase == purchase
  end

  def test_equality_with_different_class
    purchase = Purchase.create(name: "foo", calories: 130, price: 1.50)
    refute purchase == "Purchase"
  end

  def test_equality_with_different_purchase
    purchase1 = Purchase.create(name: "foo", calories: 130, price: 1.50)
    purchase2 = Purchase.create(name: "bar", calories: 130, price: 1.50)
    refute purchase1 == purchase2
  end

  def test_equality_with_same_purchase_different_object_id
    purchase1 = Purchase.create(name: "foo", calories: 130, price: 1.50)
    purchase2 = Purchase.find(purchase1.id)
    assert purchase1 == purchase2
  end
end
