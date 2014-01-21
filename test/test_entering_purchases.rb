require_relative 'helper'

class TestEnteringPurchases < MiniTest::Unit::TestCase
  def test_valid_purchase_gets_saved
    skip "needs implementation"
    assert false, "Missing test implementation"
  end

  def test_invalid_purchase_doesnt_get_saved
    skip "needs implementation"
    assert false, "Missing test implementation"
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
    expected = "You must provide the name of the product you are adding."
    assert_command_output expected, command
  end
end
