class Rook
  attr_reader :icon, :color, :location
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2656" : "\u265C"
  end

  def change_location(coordinates)
    @location = coordinates
  end
  
end