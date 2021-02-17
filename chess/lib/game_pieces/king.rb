class King
  attr_reader :icon, :color, :location
  
  def initialize(color)
    @color = color
    @location = @color == "white" ? "e1" : "e8"
    @icon = @color == "white" ? "\u2654" : "\u265A"
  end

  def change_location(coordinates)
    @location = coordinates
  end
end