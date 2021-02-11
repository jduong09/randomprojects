class Rook
  attr_accessor :location
  attr_reader :icon
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2656" : "\u265C"
  end
  
end