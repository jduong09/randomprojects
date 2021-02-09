class Pawn
  def initialize(color)
    @color = color
    @location = nil
    @icon = @color == "white" ? "\u2659" : "\u265F"
  end
  
end