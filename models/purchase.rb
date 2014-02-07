class Purchase < ActiveRecord::Base
  belongs_to :category

  default_scope { order("name ASC") }
  scope :search, ->(search_term){ where("name LIKE ?", "%#{search_term}%") }

  before_create :set_default_category

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
