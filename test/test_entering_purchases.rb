require_relative 'helper'

class TestEnteringPurchases < GroceryTest
  def test_user_is_presented_with_category_list
    cat1 = Category.find_or_create_by(name: "Foo")
    cat2 = Category.find_or_create_by(name: "Bar")
    cat3 = Category.find_or_create_by(name: "Cereal")
    shell_output = ""
    IO.popen('./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test', 'r+') do |pipe|
      pipe.puts "2"
      shell_output = pipe.read
    end
    assert_includes_in_order shell_output,
      "Choose a category:",
      "1. Bar",
      "2. Cereal",
      "3. Foo"
  end

  def test_user_chooses_category
    cat1 = Category.find_or_create_by(name: "Foo")
    cat2 = Category.find_or_create_by(name: "Bar")
    cat3 = Category.find_or_create_by(name: "Cereal")
    shell_output = ""
    IO.popen('./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test', 'r+') do |pipe|
      pipe.puts "2"
      shell_output = pipe.read
    end
    expected = "A purchase named Cheerios (Cereal), with 210 calories and $1.50 cost was created."
    assert_in_output shell_output, expected
  end

  def test_user_skips_entering_category
    cat3 = Category.find_or_create_by(name: "Cereal")
    shell_output = ""
    IO.popen('./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test', 'r+') do |pipe|
      pipe.puts ""
      shell_output = pipe.read
    end
    expected = "A purchase named Cheerios (Unknown), with 210 calories and $1.50 cost was created."
    assert_in_output shell_output, expected
  end

  def test_valid_purchase_information_gets_printed
    command = "./grocerytracker add Cheerios --calories 210 --price 1.50"
    expected = "A purchase named Cheerios (Unknown), with 210 calories and $1.50 cost was created."
    assert_command_output expected, command
  end

  def test_valid_purchase_gets_saved
    execute_popen("./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test")
    purchase = Purchase.all.first
    expected = ["Cheerios", 210, 1.50]
    actual = [purchase.name, purchase.calories, purchase.price]
    assert_equal expected, actual
    assert_equal 1, Purchase.count
  end

  def test_invalid_purchase_doesnt_get_saved
    execute_popen("./grocerytracker add Cheerios --calories 210")
    assert_equal 0, Purchase.count
  end

  def test_error_message_for_missing_price
    command = "./grocerytracker add Cheerios --calories 210"
    expected = "You must provide the price of the product you are adding."
    assert_command_output expected, command
  end

  def test_error_message_for_missing_calories_and_price
    command = "./grocerytracker add Cheerios"
    expected = "You must provide the price and total calories of the product you are adding."
    assert_command_output expected, command
  end

  def test_error_message_for_missing_calories
    command = "./grocerytracker add Cheerios --price 1.50"
    expected = "You must provide the total calories of the product you are adding."
    assert_command_output expected, command
  end

  def test_error_message_for_missing_name
    command = "./grocerytracker add"
    expected = "You must provide the name of the product you are adding. You must provide the price and total calories of the product you are adding."
    assert_command_output expected, command
  end
end
