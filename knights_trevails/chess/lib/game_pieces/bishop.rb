class Bishop
  def initialize(color)
    @color = color
    @location = nil
    @icon = @color == "white" ? "\u2657" : "\u265D"
  end

end