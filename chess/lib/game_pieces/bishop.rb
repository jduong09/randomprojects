class Bishop
  
  attr_reader :icon, :color, :location, :name
  
  def initialize(color, location)
    @name = "B"
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2657" : "\u265D"
  end

  #location is an index of the board ex: [1,1]
  def moves(location, moves = [])    
    row = location[0]
    col = location[1]
    diagonal_top_left(row, col, moves)
    diagonal_top_right(row, col, moves)
    diagonal_bot_left(row, col, moves)
    diagonal_bot_right(row, col, moves)

    moves
  end

  def diagonal_top_left(row, col, moves)
    return if invalid_move?([row - 1, col - 1])

    moves << [row - 1, col - 1]

    diagonal_top_left(row - 1, col - 1, moves)
    
    return moves 
  end

  def diagonal_top_right(row, col, moves)
    return if invalid_move?([row - 1, col + 1])

    moves << [row - 1, col + 1]

    diagonal_top_right(row - 1, col + 1, moves)

    return moves
  end

  def diagonal_bot_left(row, col, moves)
    return if invalid_move?([row + 1, col - 1])

    moves << [row + 1, col - 1]

    diagonal_bot_left(row + 1, col - 1, moves)

    return moves
  end

  def diagonal_bot_right(row, col, moves)
    return if invalid_move?([row + 1, col + 1])

    moves << [row + 1, col + 1]

    diagonal_bot_right(row + 1, col + 1, moves)

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