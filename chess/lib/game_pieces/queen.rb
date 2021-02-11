class Queen
  attr_accessor :location
  attr_reader :icon
  
  def initialize(color)
    @color = color
    @location = @color == "white" ? "d1" : "d8"
    @icon = @color == "white" ? "\u2655" : "\u265B"
  end
end