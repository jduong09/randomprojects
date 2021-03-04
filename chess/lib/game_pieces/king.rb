class King
  attr_reader :icon, :color, :location, :name, :game_moves

  def initialize(color)
    @name = "K"
    @color = color
    @location = @color == "white" ? "e1" : "e8"
    @icon = @color == "white" ? "\u2654" : "\u265A"
    @game_moves = [@location]
  end

  def moves(location, moves = [])
    king_directions = [[-1, -1], [-1, 1], [1, 1], [1,-1], [-1, 0], [1, 0], [0, -1], [0, 1]]
    
    king_directions.each do |direction|
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
    @game_moves << coordinates
  end
end