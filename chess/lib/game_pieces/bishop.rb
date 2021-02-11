class Bishop
  attr_accessor :location
  attr_reader :icon
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2657" : "\u265D"
  end

end