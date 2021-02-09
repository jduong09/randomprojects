class Knight
  def initialize(color)
    @color = color
    @location = nil
    @icon = @color == "white" ? "\u2658" : "\u265E"
  end
end