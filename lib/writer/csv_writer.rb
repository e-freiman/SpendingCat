module Writer
  class CSVWriter
    def initialize(output_items)
      @output_items = output_items
    end

    def write(filename, console = false)
      Dir.mkdir('output') unless Dir.exist?('output')
      CSV.open(filename, 'wb') do |csv|
        @output_items.each do |output_item|
          arr = [output_item.name, sprintf("$%.0f", output_item.amount)].concat(output_item.notes)
          puts arr.join("\t") if console
          csv << arr
        end
      end
    end
  end
end
