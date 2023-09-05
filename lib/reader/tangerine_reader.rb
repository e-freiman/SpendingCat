require_relative 'input_item'

module Reader
  class Tangerine
    START = 1

    attr_reader :input_items

    def initialize(filename)
      @input_items = []

      CSV.foreach((filename), headers: true, col_sep: ",") do |row|
        date = Date.strptime(row[0], '%m/%d/%Y')
        description = row[2]

        category = row[3]&.match(/Category: (.*)/)&.captures&.first

        amount = -row[4].to_f
        next if amount < 0

        @input_items << InputItem.new(date, description, amount, "#{category}")
      end

    end
  end
end
