module Writer
  class OutputItem
    attr_reader :date, :name, :amount, :notes
    attr_accessor :aggregated

    def initialize(date, name, amount, notes = [])
      @date = date
      @name = name
      @amount = amount
      @aggregated = false
      @notes = notes
    end

    def to_s
      "#{name}\t#{amount}"
    end
  end
end