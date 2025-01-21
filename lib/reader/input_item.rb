module Reader
  class InputItem
    attr_reader :date, :description, :amount, :category
    attr_accessor :notes

    def initialize(date, description, amount, category)
      @date = date
      @description = description
      @amount = amount
      @category = category
      @notes = []
    end
  end
end
