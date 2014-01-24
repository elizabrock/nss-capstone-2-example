class Purchase
  attr_accessor :name, :price, :calories

  def initialize attributes = {}
    # Long Way: @price = attributes[:price]
    # Short Way:
    attributes.each_pair do |attribute, value|
      self.send("#{attribute}=", value)
    end
  end

  def to_s
    "#{name}: #{calories} calories, $#{price}"
  end
end
