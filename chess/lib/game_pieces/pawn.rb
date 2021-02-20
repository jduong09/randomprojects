class Pawn
  attr_reader :icon, :color, :location, :name
  
  def initialize(color, location)
    @name = "P"
    @color = color
    @location = location
    @icon = @color == "white" ? "\u2659" : "\u265F"
    @game_moves = []
  end

  #Pawn can always go one forward as long as there is an open space.
  #Pawn can go one diagonal if there is an enemy, therefore taking the enemies piece.
  #Pawn can go two spots forward at the start of a match.
  #When Pawn reaches the other end of the board, it can be upgraded.
  def moves(location, moves = [])
    if @color == "white" 
      #if the pawn has not move, it can move 2 spaces forward.
      if @game_moves.empty?
        direction = [location[0] - 2, location[1]]
        return if invalid_move?(direction)
        moves << direction
      end

      row = location[0] - 1
      col = location[1]
      return if invalid_move?([row, col])
      moves << [row, col]
    else

      if @game_moves.empty?
        direction = [location[0] + 2, location[1]]
        return if invalid_move?(direction)
        moves << direction
      end

      row = location[0] + 1
      col = location[1]
      return if invalid_move?([row, col])
      moves << [row, col]
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