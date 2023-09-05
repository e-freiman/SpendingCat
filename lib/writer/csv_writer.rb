module Writer
  class CSVWriter
    def initialize(output_items)
      @output_items = output_items
    end

    def write(filename, console = false)
      Dir.mkdir('output') unless Dir.exists?('output')
      CSV.open(filename, 'wb') do |csv|
        @output_items.each do |output_item|
          puts output_item if console
          out_arr = if output_item.aggregated
                      [output_item.name, output_item.amount].concat(output_item.notes)
                    else
                      ['',output_item.date, output_item.name, output_item.amount].concat(output_item.notes)
                    end
          csv << out_arr
        end
      end
    end
  end
end