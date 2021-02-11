class King
  attr_accessor :location
  attr_reader :icon
  
  def initialize(color)
    @color = color
    @location = @color == "white" ? "e1" : "e8"
    @icon = @color == "white" ? "\u2654" : "\u265A"
  end
end