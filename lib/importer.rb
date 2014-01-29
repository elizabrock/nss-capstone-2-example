require 'csv'

class Importer
  def self.import(from_filename)
    CSV.foreach(from_filename, headers: true) do |row_hash|
      purchase = Purchase.create(
        name: row_hash["product"],
        calories: row_hash["calories"].to_i,
        price: row_hash["price"].to_f
      )
    end
  end
end