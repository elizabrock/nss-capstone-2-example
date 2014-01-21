require_relative 'helper'

class TestEnteringPurchases < MiniTest::Unit::TestCase
  def test_valid_purchase_gets_saved
    assert false, "Missing test implementation"
  end

  def test_invalid_purchase_doesnt_get_saved
    assert false, "Missing test implementation"
  end

  def test_error_message_for_missing_price
    assert false, "Missing test implementation"
  end

  def test_error_message_for_missing_calories
    assert false, "Missing test implementation"
  end

  def test_error_message_for_missing_name
    command = "./grocerytracker add"
    expected = "You must provide the name of the product you are adding."
    assert_command_output expected, command
  end
end
