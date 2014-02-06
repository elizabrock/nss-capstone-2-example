class Category
  attr_accessor :name
  attr_reader :id

  def self.default
    @@default ||= Category.find_or_create("Unknown")
  end

  def initialize(name)
    self.name = name
  end

  def name=(name)
    @name = name.strip
  end

  def self.count
    database = Environment.database_connection
    database.execute("select count(id) from categories")[0][0]
  end

  def self.all
    database = Environment.database_connection
    database.results_as_hash = true
    results = database.execute("select * from categories order by name ASC")
    results.map do |row_hash|
      category = Category.new(row_hash["name"])
      category.send("id=", row_hash["id"])
      category
    end
  end

  def self.find_or_create name
    database = Environment.database_connection
    database.results_as_hash = true
    category = Category.new(name)
    results = database.execute("select * from categories where name = '#{category.name}'")

    if results.empty?
      database.execute("insert into categories(name) values('#{category.name}')")
      category.send("id=", database.last_insert_row_id)
    else
      row_hash = results[0]
      category.send("id=", row_hash["id"])
    end
    category
  end

  protected

  def id=(id)
    @id = id
  end
end
