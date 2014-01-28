class Category
  attr_accessor :name
  attr_reader :id

  def initialize(attributes = {})
    @name = attributes[:name]
  end

  def self.all
    database = Environment.database_connection
    database.results_as_hash = true
    results = database.execute("select * from categories order by name ASC")
    results.map do |row_hash|
      category = Category.new(name: row_hash["name"])
      category.send("id=", row_hash["id"])
      category
    end
  end

  def self.create arguments
    category = Category.new(arguments)
    database = Environment.database_connection
    database.execute("insert into categories(name) values('#{category.name}')")
    category.send("id=", database.last_insert_row_id)
    category
  end

  protected

  def id=(id)
    @id = id
  end
end
