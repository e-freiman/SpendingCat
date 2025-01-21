require_relative 'wildcards'

# Unification of transaction categories from different banks
class Cat
  attr_accessor :desc_dict
  attr_accessor :original_desc_dict
  attr_accessor :min_date
  attr_accessor :max_date
  attr_accessor :total

  def initialize(cat_map_filename)
      # hash where key is transaction description and value is total amount spent
    @desc_dict = {}
    @original_desc_dict = {}
    @total = 0
    @min_date = nil
    @max_date = nil
    @category_map = read_category_map(cat_map_filename)
  end

  def process_input(input_item)
    @min_date = input_item.date if min_date == nil || input_item.date < min_date
    @max_date = input_item.date if max_date == nil || input_item.date > max_date
    @total += input_item.amount

    description = process_description(input_item.description)

    if @desc_dict[description]
      @desc_dict[description] += input_item.amount
      @original_desc_dict[description] << input_item.description unless @original_desc_dict[description].include?(input_item.description)
    else
      @desc_dict[description] = input_item.amount
      @original_desc_dict[description] = [input_item.description]
    end
  end

  def get_category(desc)
    if @category_map.has_key?(desc)
      @category_map[desc]
    else
      'Not Marked'
    end
  end

  # returns hash where key is category and value is the amount spent under given category
  def categorize
    cat_dict = {}
    @desc_dict.each do |desc, amount|
      cat = get_category(desc)

      if cat_dict[cat]
        cat_dict[cat] += amount
      else
        cat_dict[cat] = amount
      end
    end

    cat_dict
  end

  private

  def process_description(description)
    # removes all non-alphanumeric characters and spaces
    processed_description = description.split(' ')[0..1].join(' ').gsub(/[^a-z]/i, '').downcase

    match = DESCRIPTION_OVERRIDE.find {|k, v| v.find { |e| processed_description =~/#{e}/i || description =~/#{e}/i} }
    if match
      match.first
    else
      processed_description
    end
  end

  def read_category_map(filename)
    workbook = Roo::Spreadsheet.open filename
    sheet_name = workbook.sheets[0]
    sheet = workbook.sheet(sheet_name)
    sheet.parse(clean: true)

    category_map = {}
    sheet.each do |row|
      category_map[row[0]] = row[2] unless row[2].nil? or row[2].empty?
    end
    category_map
  end

end
