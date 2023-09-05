require_relative 'wildcards'

# Unification of transaction categories from different banks
class Cat
  # hash where key is refined category and value is the array of transactions
  # that were mapped to a given category
  attr_reader :cat_dict

  def initialize
    @cat_dict = {}
  end

  def process(input_item)
    # check if we infer category from description
    cat_override = cat_by_description(input_item.description)

    cat = if cat_override and cat != cat_override
            input_item.notes << "#{input_item.category} overriden by description"
            cat_override
          else
            input_item.category
          end

    # save to the categories dictionary
    @cat_dict[cat] = [] unless @cat_dict[cat]
    @cat_dict[cat] << input_item
  end

  private

  def cat_by_description(description)
    match = CAT_BY_DESCRIPTION_OVERRIDE.find {|k, v| v.find { |e| description =~/#{e}/} }
    match.first if match
  end
end
