class Player
  attr_accessor :color
  attr_reader :name

  def initialize(name)
    @name = name
    @color = nil
  end

  def assign_color(color)
    @color = color
  end
end