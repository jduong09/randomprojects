class Rook
  attr_reader :icon, :color, :location
  
  def initialize(color, location)
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2656" : "\u265C"
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

  def change_location(coordinates)
    @location = coordinates
  end
  
end