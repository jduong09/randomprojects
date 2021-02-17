class Queen
  attr_reader :icon, :color, :location
  
  def initialize(color)
    @color = color
    @location = @color == "white" ? "d1" : "d8"
    @icon = @color == "white" ? "\u2655" : "\u265B"
  end

  def change_location(coordinates)
    @location = coordinates
  end
end