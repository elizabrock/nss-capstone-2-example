require_relative 'helper'

class TestCategories < GroceryTest
  def test_categories_are_created_if_needed
    foos_before = database.execute("select count(id) from categories")[0][0]
    Category.find_or_create("Foo")
    foos_after = database.execute("select count(id) from categories")[0][0]
    assert_equal foos_before + 1, foos_after
  end

  def test_categories_are_not_created_if_they_already_exist
    Category.find_or_create("Foo")
    foos_before = database.execute("select count(id) from categories")[0][0]
    Category.find_or_create("Foo")
    foos_after = database.execute("select count(id) from categories")[0][0]
    assert_equal foos_before, foos_after
  end

  def test_existing_category_is_returned_by_find_or_create
    category1 = Category.find_or_create("Foo")
    category2 = Category.find_or_create("Foo")
    assert_equal category1.id, category2.id, "Category ids should be identical"
  end

  def test_create_creates_an_id
    category = Category.find_or_create("Foo")
    refute_nil category.id, "Category id shouldn't be nil"
  end

  def test_all_returns_all_categories_in_alphabetical_order
    Category.find_or_create("foo")
    Category.find_or_create("bar")
    expected = ["bar", "foo"]
    actual = Category.all.map{ |category| category.name }
    assert_equal expected, actual
  end

  def test_all_returns_empty_array_if_no_categories
    results = Category.all
    assert_equal [], results
  end
end
