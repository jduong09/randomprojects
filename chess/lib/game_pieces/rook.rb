class Rook
  attr_reader :icon, :color, :location, :name
  
  def initialize(color, location)
    @name = "R"
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2656" : "\u265C"
  end

  def moves(location, moves = [])    
    row = location[0]
    col = location[1]

    north_moves(row, col, moves)
    south_moves(row, col, moves)
    east_moves(row, col, moves)
    west_moves(row, col, moves)

    moves
  end

  def north_moves(row, col, moves)
    return if invalid_move?([row - 1, col])

    moves << [row - 1, col]

    north_moves(row - 1, col, moves)
    
    return moves 
  end

  def south_moves(row, col, moves)
    return if invalid_move?([row + 1, col])

    moves << [row + 1, col]

    south_moves(row + 1, col, moves)
    
    return moves 
  end

  def east_moves(row, col, moves)
    return if invalid_move?([row, col + 1])

    moves << [row, col + 1]

    east_moves(row, col + 1, moves)
    
    return moves 
  end

  def west_moves(row, col, moves)
    return if invalid_move?([row, col - 1])

    moves << [row, col - 1]

    west_moves(row, col - 1, moves)
    
    return moves 
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