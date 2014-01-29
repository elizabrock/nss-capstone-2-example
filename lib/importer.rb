require 'csv'

class Importer
  def self.import(from_filename)
    categories_to_create = []
    CSV.foreach(from_filename, headers: true) do |row_hash|
      import_product(row_hash)
      categories_to_create << row_hash["category"]
    end

    categories_to_create.uniq.each do |name|
      Category.create(name: name)
    end
  end

  def self.import_product(row_hash)
    purchase = Purchase.create(
      name: row_hash["product"],
      calories: row_hash["calories"].to_i,
      price: row_hash["price"].to_f
    )
  end
end
