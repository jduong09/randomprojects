class Cell
  attr_reader :value
  
  def initialize(value="-")
    @value = value
  end

  def change_value(value)
    @value = value
  end
end
