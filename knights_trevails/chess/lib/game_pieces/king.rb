class King
  def initialize(color)
    @color = color
    @location = nil
    @icon = @color == "white" ? "\u2654" : "\u265A"
  end
end