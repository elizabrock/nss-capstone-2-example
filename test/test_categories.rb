require_relative 'helper'

class TestCategories < GroceryTest
  def test_default_creates_correctly_named_file
    category = Category.default
    assert_equal "Unknown", category.name
    refute category.new_record?
  end

  def test_default_creates_default_category
    assert_equal 0, Category.count
    Category.default
    assert_equal 1, Category.count
  end

  def test_default_doesnt_create_duplicate_default
    category = Category.find_or_create_by(name: "Unknown")
    assert_equal category.id, Category.default.id
    assert_equal 1, Category.count
  end

  def test_count_when_no_categories
    assert_equal 0, Category.count
  end

  def test_count_of_multiple_categories
    Category.find_or_create_by(name: "foo")
    Category.find_or_create_by(name: "Corn")
    Category.find_or_create_by(name: "Cornflakes")
    assert_equal 3, Category.count
  end

  def test_categories_are_created_if_needed
    foos_before = Category.count
    Category.find_or_create_by(name: "Foo")
    foos_after = Category.count
    assert_equal foos_before + 1, foos_after
  end

  def test_categories_are_not_created_if_they_already_exist
    Category.find_or_create_by(name: "Foo")
    foos_before = Category.count
    Category.find_or_create_by(name: "Foo")
    foos_after = Category.count
    assert_equal foos_before, foos_after
  end

  def test_existing_category_is_returned_by_find_or_create
    category1 = Category.find_or_create_by(name: "Foo")
    category2 = Category.find_or_create_by(name: "Foo")
    assert_equal category1.id, category2.id, "Category ids should be identical"
  end

  def test_create_creates_an_id
    category = Category.find_or_create_by(name: "Foo")
    refute_nil category.id, "Category id shouldn't be nil"
  end

  def test_all_returns_all_categories_in_alphabetical_order
    Category.find_or_create_by(name: "foo")
    Category.find_or_create_by(name: "bar")
    expected = ["bar", "foo"]
    actual = Category.all.map{ |category| category.name }
    assert_equal expected, actual
  end

  def test_all_returns_empty_array_if_no_categories
    results = Category.all
    assert_equal [], results
  end
end
