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

dict = {}
total = 0
min_date = nil
max_date = nil

cat = Cat.new

Dir.foreach('data') do |bank_name|
  next if bank_name.start_with? '.' or File.file? bank_name
  puts "Processing #{bank_name.capitalize} data"

  Dir.foreach("data/#{bank_name}") do |file_name|
    next if file_name.start_with? '.' or file_name.start_with?('category_map')
    puts "\t#{file_name}"
    reader = register[bank_name].new("data/#{bank_name}/#{file_name}")

    reader.input_items.each do |input_item|
      min_date = input_item.date if min_date == nil || input_item.date < min_date
      max_date = input_item.date if max_date == nil || input_item.date > max_date

      cat.process(input_item)

      total += input_item.amount
    end
  end
end

# Output all items
output = []
cat.cat_dict.each do |cat, items|
  category_item = Writer::OutputItem.new(nil, cat, items.sum(&:amount))
  category_item.aggregated = true
  output << category_item
  output.concat(
    items.map { |item| Writer::OutputItem.new(item.date, item.description, item.amount, item.notes) }
         .sort_by { |item| -item.amount }
  )
end

Writer::CSVWriter.new(output).write('output/items.csv')

# Output categories
output = []
cat.cat_dict.each do |cat, items|
  category_item = Writer::OutputItem.new(nil, cat, items.sum(&:amount).to_i)
  category_item.aggregated = true
  output << category_item
end

puts ''
Writer::CSVWriter.new(output.sort_by(&:amount)).write('output/categories.csv', true)
puts ''

puts "total: #{total}"
puts "min_date: #{min_date}"
puts "max_date: #{max_date}"
