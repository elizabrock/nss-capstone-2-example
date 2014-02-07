class Category < ActiveRecord::Base
  default_scope { order("name ASC") }

  def self.default
    Category.find_or_create_by(name: "Unknown")
  end
end
