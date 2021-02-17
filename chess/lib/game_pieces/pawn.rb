class Pawn
  attr_reader :icon, :color, :location
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2659" : "\u265F"
  end
  
  def change_location(coordinates)
    @location = coordinates
  end
end