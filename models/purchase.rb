class Purchase
  attr_accessor :name, :price, :calories

  def initialize attributes = {}
    # @price = attributes[:price]
    # @calories = attributes[:calories]
    # @name = attributes[:name]
    # ^ Long way
    # Short way:
    [:name, :price, :calories].each do |attr|
      self.send("#{attr}=", attributes[attr])
    end
  end

  def save
    database = Environment.database_connection
    database.execute("insert into purchases(name, calories, price) values('#{name}', #{calories}, #{price})")
    # ^ fails silently!!
    # ^ Also, susceptible to SQL injection!
  end

  def self.all
    database = Environment.database_connection
    database.results_as_hash = true
    results = database.execute("select * from purchases order by name ASC")
    results.map do |row_hash|
      Purchase.new(name: row_hash["name"], price: row_hash["price"], calories: row_hash["calories"])
    end
  end

  def to_s
    formatted_price = sprintf('%.2f', price)
    "#{name}: #{calories} calories, $#{formatted_price}"
  end
end
