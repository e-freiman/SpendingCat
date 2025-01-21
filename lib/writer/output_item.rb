module Writer
  class OutputItem
    attr_reader :name, :amount, :notes

    def initialize(name, amount, notes = [])
      @name = name
      @amount = amount
      @notes = notes
    end

    def to_s
      "#{name}\t#{amount}".join(no)
    end
  end
end
