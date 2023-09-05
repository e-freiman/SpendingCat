module Reader
  class InputItem
    attr_reader :date, :description, :amount, :category
    attr_accessor :notes

    def initialize(date, description, amount, category)
      category = 'Other' if category == nil || category.empty?
      @date = date
      @description = description
      @amount = amount
      @category = category
      @notes = []
    end

    def to_s
      "#{@date}, #{@description}, #{@amount}, #{@category}, #{@note}"
    end
  end
end
