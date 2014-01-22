require 'optparse'

class ParseArguments
  def self.parse
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: grocerytracker [command] [options]"

      opts.on("--price [PRICE]", "The price") do |price|
        options[:price] = price
      end

      opts.on("--calories [CALORIES]", "The calories") do |calories|
        options[:calories] = calories
      end
    end.parse!
    options
  end

  def self.validate options
    errors = []
    if options[:name].nil? or options[:name].empty?
      errors << "You must provide the name of the product you are adding.\n"
    end

    missing_things = []
    missing_things << "price" unless options[:price]
    missing_things << "total calories" unless options[:calories]
    unless missing_things.empty?
      errors << "You must provide the #{missing_things.join(" and ")} of the product you are adding.\n"
    end
    errors
  end
end
