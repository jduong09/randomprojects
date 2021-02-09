class Queen
  def initialize(color)
    @color = color
    @location = nil
    @icon = @color == "white" ? "\u2655" : "\u265B"
  end
end