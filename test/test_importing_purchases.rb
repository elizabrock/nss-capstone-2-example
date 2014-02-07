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
    import_data
    expected = [
      "Corn Flakes, 4.0, 3000, Cereals",
      "Panera Sandwich, 4.0, 450, Prepared Meals",
      "Panera Soup, 5.5, 450, Soups",
      "Rice Krispies, 3.4, 2000, Cereals",
    ]
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
    Category.find_or_create_by(name: "Cereals")
    Category.find_or_create_by(name: "Pets")
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
