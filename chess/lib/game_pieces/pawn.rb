class Pawn
  attr_accessor :location
  attr_reader :icon
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2659" : "\u265F"
  end
  
end