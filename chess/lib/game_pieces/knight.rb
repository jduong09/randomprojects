class Knight
  attr_accessor :location
  attr_reader :icon
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2658" : "\u265E"
  end
end