require 'roo-xls'
require_relative 'input_item'
require 'pathname'

module Reader
  class Amex
    START = 12

    attr_reader :input_items

    def initialize(filename)
      workbook = Roo::Spreadsheet.open filename
      sheet_name = workbook.sheets[0]
      sheet = workbook.sheet(sheet_name)
      sheet.parse(clean: true)

      row_index = -1
      @input_items = []
      sheet.each do |row|
        row_index += 1
        next if row_index < START

        date = Date.strptime(row[0], '%d %b %Y')
        description = row[2]
        amount = row[4].tr('$','').tr(',','').to_f
        category = row[8]
        next if amount < 0

        input_item = InputItem.new(date, description, amount, category)
        if category != row[8]
          input_item.notes << "original category: #{row[8]}"
        end

        @input_items << input_item
      end
    end
  end
end
