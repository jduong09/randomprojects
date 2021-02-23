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
    northwest_moves(row, col, moves)
    northeast_moves(row, col, moves)
    southwest_moves(row, col, moves)
    southeast_moves(row, col, moves)

    moves
  end

  def northwest_moves(row, col, moves)
    return if invalid_move?([row - 1, col - 1])

    moves << [row - 1, col - 1]

    northwest_moves(row - 1, col - 1, moves)
    
    return moves 
  end

  def northeast_moves(row, col, moves)
    return if invalid_move?([row - 1, col + 1])

    moves << [row - 1, col + 1]

    northeast_moves(row - 1, col + 1, moves)

    return moves
  end

  def southwest_moves(row, col, moves)
    return if invalid_move?([row + 1, col - 1])

    moves << [row + 1, col - 1]

    southwest_moves(row + 1, col - 1, moves)

    return moves
  end

  def southeast_moves(row, col, moves)
    return if invalid_move?([row + 1, col + 1])

    moves << [row + 1, col + 1]

    southeast_moves(row + 1, col + 1, moves)

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