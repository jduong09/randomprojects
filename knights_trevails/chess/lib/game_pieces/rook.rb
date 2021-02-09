class Rook
  def initialize(color)
    @color = color
    @location = nil
    @icon = @color == "white" ? "\u2656" : "\u265C"
  end
  
end