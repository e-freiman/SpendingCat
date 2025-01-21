require_relative 'reader/amex_reader'
require_relative 'reader/tangerine_reader'
require_relative 'writer/csv_writer'
require_relative 'writer/output_item'
require_relative 'cat'

puts 'Hello Cat'

register = {
  'amex' => Reader::Amex,
  'tangerine' => Reader::Tangerine,
}

cat = Cat.new("data/category_map.xls")

# Read all data and combine identical categories

Dir.foreach('data') do |bank_name|
  next if bank_name.start_with?('.') || bank_name.start_with?('category_map')
  puts "Processing #{bank_name.capitalize} data"

  Dir.glob("**/*", base: "data/#{bank_name}") do |file_name|
    relative_path = "data/#{bank_name}/#{file_name}"
    next if file_name.start_with?('.') || File.directory?(relative_path)
    puts "\t#{relative_path}"
    reader = register[bank_name].new(relative_path)
    reader.input_items.each do |input_item|
      cat.process_input(input_item)
    end
  end
end

cat_dict = cat.categorize
# Output all items
output = []
cat.desc_dict.each do |desc, amount|
  output << Writer::OutputItem.new(desc, amount, [cat.get_category(desc)].concat([cat.original_desc_dict[desc].join(', ')]))
end
puts ''
Writer::CSVWriter.new(output.sort_by {|item| -item.amount}).write('output/items.csv', true)
# Output categories
output = []
cat_dict.each do |desc, amount|
  output << Writer::OutputItem.new(desc, amount)
end
puts ''
Writer::CSVWriter.new(output.sort_by {|item| -item.amount}).write('output/categories.csv', true)

puts ''
puts "total: #{sprintf("$%.0f", cat.total)}"
puts "min_date: #{cat.min_date}"
puts "max_date: #{cat.max_date}"
puts "items: #{cat.desc_dict.length}"
puts "categories: #{cat_dict.length}"
