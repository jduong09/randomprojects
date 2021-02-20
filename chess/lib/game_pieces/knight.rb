class Knight
  attr_reader :icon, :color, :location, :name

  def initialize(color, location)
    @name = "N"
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2658" : "\u265E"
  end

  def moves(location, moves = [])
    knight_directions = [[-2, -1], [-2, 1], [2, 1], [2,-1], [-1, 2], [-1, -2], [1, 2], [1, -2]]
    
    knight_directions.each do |direction|
      row = location[0] + direction[0]
      col = location[1] + direction[1]
      next if invalid_move?([row, col])
      direction = [row, col]
      moves << direction
    end

    moves
  end

  def invalid_move?(move)
    if move[0] < 1 || move[0] > 8
      return true
    elsif move[1] < 1 || move[1] > 8
      return true
    else
      return false
    end
  end

  def change_location(coordinates)
    @location = coordinates
  end
end