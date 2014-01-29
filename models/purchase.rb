class Purchase
  attr_accessor :name, :price, :calories, :category
  attr_reader :id

  def initialize attributes = {}
    update_attributes(attributes)
  end

  def price=(price)
    @price = price.to_f
  end

  def calories=(calories)
    @calories = calories.to_i
  end

  def self.create(attributes = {})
    purchase = Purchase.new(attributes)
    purchase.save
    purchase
  end

  def update attributes = {}
    update_attributes(attributes)
    save
  end

  def save
    database = Environment.database_connection
    category_id = category.nil? ? "NULL" : category.id
    if id
      database.execute("update purchases set name = '#{name}', calories = '#{calories}', price = '#{price}', category_id = #{category_id} where id = #{id}")
    else
      database.execute("insert into purchases(name, calories, price, category_id) values('#{name}', #{calories}, #{price}, #{category_id})")
      @id = database.last_insert_row_id
    end
    # ^ fails silently!!
    # ^ Also, susceptible to SQL injection!
  end

  def self.find id
    database = Environment.database_connection
    database.results_as_hash = true
    results = database.execute("select * from purchases where id = #{id}")[0]
    if results
      purchase = Purchase.new(name: results["name"], price: results["price"], calories: results["calories"])
      purchase.send("id=", results["id"])
      purchase
    else
      nil
    end
  end

  def self.search(search_term = nil)
    database = Environment.database_connection
    database.results_as_hash = true
    results = database.execute("select purchases.* from purchases where name LIKE '%#{search_term}%' order by name ASC")
    results.map do |row_hash|
      purchase = Purchase.new(
                  name: row_hash["name"],
                  price: row_hash["price"],
                  calories: row_hash["calories"])
      # Ideally: purchase.category = Category.find(row_hash["category_id"])
      # Not Ideally :(
      category = Category.all.find{|category| category.id == row_hash["category_id"]}
      purchase.category = category
      purchase.send("id=", row_hash["id"])
      purchase
    end
  end

  # class << self
  #   alias :all :search
  # end
  # ^ is an alternative to:
  def self.all
    search
  end

  def price
    sprintf('%.2f', @price) if @price
  end

  def to_s
    "#{name}: #{calories} calories, $#{price}, id: #{id}"
  end

  def ==(other)
    other.is_a?(Purchase) && self.to_s == other.to_s
  end

  protected

  def id=(id)
    @id = id
  end

  def update_attributes(attributes)
    # @price = attributes[:price]
    # @calories = attributes[:calories]
    # @name = attributes[:name]
    # ^ Long way
    # Short way:
    [:name, :price, :calories, :category].each do |attr|
      if attributes[attr]
        # self.calories = attributes[:calorie]
        self.send("#{attr}=", attributes[attr])
      end
    end
  end
end
