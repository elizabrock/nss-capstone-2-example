require_relative 'helper'
require 'sqlite3'

class TestEnteringPurchases < GroceryTest
  def test_valid_purchase_information_gets_printed
    command = "./grocerytracker add Cheerios --calories 210 --price 1.50"
    expected = "A purchase named Cheerios, with 210 calories and $1.50 cost was created."
    assert_command_output expected, command
  end

  def test_valid_purchase_gets_saved
    `./grocerytracker add Cheerios --calories 210 --price 1.50`
    results = database.execute("select name, calories, price from purchases")
    expected = ["Cheerios", 210, 1.50]
    assert_equal expected, results[0]

    result = database.execute("select count(id) from purchases")
    assert_equal 1, result[0][0]
  end

  def test_invalid_purchase_doesnt_get_saved
    `./grocerytracker add Cheerios --calories 210`
    result = database.execute("select count(id) from purchases")
    assert_equal 0, result[0][0]
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
    expected = "You must provide the name of the product you are adding.\nYou must provide the price and total calories of the product you are adding."
    assert_command_output expected, command
  end
end
