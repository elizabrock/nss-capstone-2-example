require_relative 'helper'
require_relative '../lib/importer'

class TestImportingPurchases < GroceryTest
  def import_data
    Importer.import("test/sample_purchase_data.csv")
  end

  def test_the_correct_number_of_purchases_are_imported
    import_data
    assert_equal 4, Purchase.all.count
  end

  def test_purchases_are_imported_fully
    skip
    import_data
    expected = ["Panera Soup, 5.50, 450, Soups",
    "Corn Flakes, 4.00, 3000, Cereals",
    "Rice Krispies, 3.40, 2000, Cereals",
    "Panera Sandwich, 4.00, 450, Prepared Meals"]
    actual = Purchase.all.map do |product|
      "#{product.name}, #{product.price}, #{product.calories}, #{product.category.name}"
    end
    assert_equal expected, actual
  end

  def test_extra_categories_arent_created
    import_data
    assert_equal 3, Category.all.count
  end

  def test_categories_are_created_as_needed
    Category.create(name: "Cereals")
    Category.create(name: "Pets")
    import_data
    assert_equal 4, Category.all.count, "The categories were: #{Category.all.map(&:name)}"
  end

  def test_data_isnt_duplicated
    import_data
    expected = ["Cereals", "Prepared Meals", "Soups"]
    assert_equal expected, Category.all.map(&:name)
    # ^equivalent:
    # category_names = Category.all.map{ |category| category.name }
    # assert_equal expected, category_names
  end
end
