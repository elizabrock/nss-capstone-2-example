class Purchase < ActiveRecord::Base
  belongs_to :category

  default_scope { order("name ASC") }

  before_create :set_default_category

  # def price=(price)
  #   @price = price.to_f
  # end

  # def calories=(calories)
  #   @calories = calories.to_i
  # end

  def self.search(search_term = nil)
    Purchase.where("name LIKE ?", "%#{search_term}%").to_a
  end

  def formatted_price
    "$%04.2f" % price
  end

  def to_s
    "#{name}: #{calories} calories, #{formatted_price}, id: #{id}"
  end

  private

  def set_default_category
    self.category ||= Category.default
  end
end
