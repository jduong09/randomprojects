class Bishop
  
  attr_reader :icon, :color, :location
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2657" : "\u265D"
  end

  def change_location(coordinates)
    @location = coordinates
  end

end