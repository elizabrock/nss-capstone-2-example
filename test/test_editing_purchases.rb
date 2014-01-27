require_relative 'helper'

class TestEditingPurchases < GroceryTest
  def test_updating_a_record_that_exists
    purchase = Purchase.new(name: "Cheerios", calories: 210, price: 1.50)
    purchase.save
    id = purchase.id
    command = "./grocerytracker edit --id #{id} --name Cheerio! --calories 10 --price .50"
    expected = "Purchase #{id} is now named Cheerio!, with 10 calories and $0.50 cost."
    # What about the db?
    assert_command_output expected, command
  end

  def test_attempting_to_update_a_nonexistant_record
    command = "./grocerytracker edit --id 218903123980123 --name Cheerio! --calories 10 --price .50"
    expected = "Purchase 218903123980123 couldn't be found."
    assert_command_output expected, command
  end

  def test_attempting_to_update_with_no_changes
    purchase = Purchase.new(name: "Cheerios", calories: 210, price: 1.50)
    purchase.save
    id = purchase.id
    command = "./grocerytracker edit --id #{id} --name Cheerios --calories 210 --price 1.50"
    expected = "Purchase #{id} is now named Cheerios, with 210 calories and $1.50 cost."
    assert_command_output expected, command
  end

  def test_attempting_to_update_with_bad_data
    skip
    purchase = Purchase.new(name: "Cheerios", calories: 210, price: 1.50)
    purchase.save
    id = purchase.id #<--- First thing we have to implement
    command = "./grocerytracker edit --id #{id} --name Cheerio! --calories 10 --price fifty"
    expected = "Purchase #{id} can't be updated.  Price must be a number."
    assert_command_output expected, command
  end

  def test_attempting_to_update_partial_data
    skip
    purchase = Purchase.new(name: "Cheerios", calories: 210, price: 1.50)
    purchase.save
    id = purchase.id #<--- First thing we have to implement
    command = "./grocerytracker edit --id #{id} --name Cheerio!"
    expected = "Purchase #{id} is now named Cheerio!, with 210 calories and $1.50 cost."
    assert_command_output expected, command
  end
end
