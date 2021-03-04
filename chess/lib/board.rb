require_relative "game_pieces/bishop.rb"
require_relative "game_pieces/king.rb"
require_relative "game_pieces/knight.rb"
require_relative "game_pieces/pawn.rb"
require_relative "game_pieces/queen.rb"
require_relative "game_pieces/rook.rb"

class Board
  attr_accessor :board
  attr_accessor :gamepieces

  def initialize
    @board = Array.new(8) { Array.new(8) {"-"} }
    @gamepieces = {}
  end

  def fill_board
    @board.each_with_index do |row, idx|
      row.unshift("#{8 - idx}")
    end
    @board.unshift([" ", "a", "b", "c", "d", "e", "f", "g", "h"])
    create_gamepieces
    add_gamepieces
    display_board
  end
 
  def gamepiece_moves(gamepiece, index)
    all_moves = gamepiece.moves(index)

    #lines 30 - 53 check if the bishop, queen, and rook have possible moves. if not, returns empty array.
    if gamepiece.name == "B"
      bishop_moves = []
      all_moves.each do |move| 
        bishop_moves << move if validate_bishop_move(gamepiece, index, move)
      end
      return bishop_moves
    end

    if gamepiece.name == "Q"
      queen_moves = []
      all_moves.each do |move| 
        queen_moves << move if validate_queen_king_move(gamepiece, index, move)
      end
      return queen_moves
    end

    if gamepiece.name == "R"
      rook_moves = []
      all_moves.each do |move| 
        rook_moves << move if validate_rook_move(gamepiece, index, move)
      end
      return rook_moves
    end

    if gamepiece.name == "K"
      king_moves = []
      all_moves.each do |move|
        king_moves << move if validate_queen_king_move(gamepiece, index, move)
      end

      #adding castling moves to king's possible moves
      if gamepiece.game_moves.length == 1
        if gamepiece.color == "white" 
          king_moves << [8,3]
          king_moves << [8,7]
        else 
          king_moves << [1,3]
          king_moves << [1,7]
        end
      end
      
      return king_moves
    end
    
    #Adds the diagonal killing moves for pawns if it is available to diagonal kill.
    #Adds the en passant moves if en passant condition is reached.
    if gamepiece.name == "P" 
      pawn_moves = []

      all_moves.each do |move|
        pawn_moves << move if validate_pawn_move(gamepiece, index, move)
      end

      if gamepiece.color == "white"
        directions = [[-1, -1], [-1, 1]]
        directions.each do |direction|
          row = index[0] + direction[0]
          col = index[1] + direction[1]
          next if invalid_move?([row, col])
          move = [row, col]
          pawn_moves << move if enemy_spot?(gamepiece.color, move)
        end
      elsif gamepiece.color == "black"
        directions = [[1, -1], [1, 1]]
        directions.each do |direction|
          row = index[0] + direction[0]
          col = index[1] + direction[1]
          next if invalid_move?([row, col])
          move = [row, col]
          pawn_moves << move if enemy_spot?(gamepiece.color, move)
        end
      end

      if en_passant?(gamepiece) != false
        enemy_index = get_rank_and_file(en_passant?(gamepiece))
        if gamepiece.color == "white"
          passing_move = [enemy_index[0] - 1, enemy_index[1]]
          pawn_moves << passing_move
        else
          passing_move = [enemy_index[0] + 1, enemy_index[1]]
          pawn_moves << passing_move
        end
      end
      
      return pawn_moves
    end

    return all_moves
  end

  def possible_moves?(gamepiece)
    index = get_rank_and_file(gamepiece.location)
    if gamepiece_moves(gamepiece, index).empty?
      return false
    else
      return true
    end
  end

  def [](row, col)
    @board[row][col]
  end

  def find_gamepiece(location)
    index = get_rank_and_file(location)
    gamepiece = @board[index[0]][index[1]]
  end

  def get_rank_and_file(coordinates)
    col = find_file(coordinates[0])
    row = find_rank(coordinates[1])
    
    return row, col
  end

  def display_board
    string = ""
    @board.each do |row|
      row_string = ""
      row.each do |col|
        if col.instance_of?(String)
          row_string += col + " "
        else
          row_string += col.icon + " "
        end
      end
      row_string += "\n"
      string += row_string
    end
    puts string
  end

  #check if move puts the gamepiece on a ally gamepiece (should not be able to do that)
  #check if move takes an enemies gamepiece (place, and remove enemies gamepiece from game.)
  #check if move runs into any ally gamepieces on the way to its destination. If it does, it cannot make that move.
    #this is not the case for Knight, which can jump over pieces.
    #Try to simulate the movement of the gamepiece in order to see if there are any ally/enemy moves resulting in a faulty move.
  def move_gamepiece(old_location, new_location, gamepiece)
    new_spot = get_rank_and_file(new_location)

    if gamepiece.name == "P" && en_passant?(gamepiece) != false
      dead_gamepiece = en_passant?(gamepiece)
      remove_gamepiece(gamepiece, dead_gamepiece)
      change_board(dead_gamepiece, "-")
    end

    # Implement the castling movement
    #queenside
      #white king goes from e1 --> c1
      #white rook goes from a1 --> d1
    #kingside
      #white king goes from e1 --> g1
      #white rook goes from h1 --> f1
    #In castling, two gamepieces move.
    if gamepiece.name == "K" 
      if gamepiece.color == "white"
        if new_location == "c1"
          rook = find_gamepiece("a1")
          if castling?(gamepiece, rook)
            execute_castling(gamepiece, rook, "c1", "d1")
          end
        end

        if new_location == "g1"
          other_rook = find_gamepiece("h1")
          if castling?(gamepiece, other_rook)
            execute_castling(gamepiece, other_rook, "g1", "f1")
          end
        end
      end

      if gamepiece.color == "black"
        if new_location == "c8"
          rook = find_gamepiece("a8")
          if castling?(gamepiece, rook)
            execute_castling(gamepiece, rook, "c8", "d8")
          end
        end

        if new_location == "g8"
          other_rook = find_gamepiece("h8")
          if castling?(gamepiece, other_rook)
            execute_castling(gamepiece, other_rook, "g8", "f8")
          end
        end

      end
    end

    change_board(old_location, "-")
    change_board(new_location, gamepiece)
    gamepiece.change_location(new_location)
    display_board
  end

  #Once in every game, each king can make a special move, known as castling. Castling consists of moving the king two squares along the first rank toward a rook on the player's first rank, and then placing the rook on the last square that the king crossed. Castling is permissible if the following conditions are met:[1]
    #Neither the king nor the rook has previously moved during the game.
    #There are no pieces between the king and the rook.
    #The king is not in check, and will not pass through or land on any square attacked by an enemy piece. (Note that castling is permitted if the rook is under attack, or if the rook crosses an attacked square.)
    def castling?(king, rook)
      if king.color == "white"
        return false if king.location != "e1"
        king_index = get_rank_and_file(king.location)
        if rook.location == "a1"
          return false if simulate_west_movement(0, 4, king_index, king) == false
          return false if safe_castle?("queenside", king.color) == false
          return true if safe_castle?("queenside", king.color)
        elsif rook.location == "h1"
          return false if simulate_east_movement(0, 3, king_index, king) == false
          return false if safe_castle?("kingside", king.color) == false
          return true if safe_castle?("kingside", king.color)
        else
          return false
        end
      elsif king.color == "black"
        return false if king.location != "e8"
        king_index = get_rank_and_file(king.location)
        if rook.location == "a8"
          return false if simulate_west_movement(0, 4, king_index, king) == false
          return false if safe_castle?("queenside", king.color) == false
          return true if safe_castle?("queenside", king.color)
        elsif rook.location == "h8"
          return false if simulate_east_movement(0, 3, king_index, king) == false
          return false if safe_castle?("kingside", king.color) == false
          return true if safe_castle?("kingside", king.color)
        else
          return false
        end
      else
        return false
      end
    end

  def execute_castling(king, rook, new_king_spot, new_rook_spot)
    change_board(king.location, "-")
    change_board(new_king_spot, king)
    change_board(rook.location, "-")
    change_board(new_rook_spot, rook)
    king.change_location(new_king_spot)
    rook.change_location(new_rook_spot)
  end

  def remove_gamepiece(gamepiece, move)
    dead_gamepiece = find_gamepiece(move)
    dead_gamepiece.change_location("dead")
    
    display_board
  end

  #Takes in the gamepiece that is being moved, and the current location of the gamepiece as an index, 
  #Also takes in new location that the gamepiece wants to be moved in, in rank/file notation
  #Making sure it is either in an open spot, or takes an enemy spot.
  #Therefore, make sure it is in the possible move array and that it doesn't land onto an ally spot.
  def valid_move?(gamepiece, index, new_location)
    possible_moves = gamepiece_moves(gamepiece, index)
    return false if possible_moves.empty?
    new_spot = get_rank_and_file(new_location)

    if !possible_moves.include?(new_spot)
      puts "That move is impossible for #{gamepiece.icon}."
      return false
    elsif @board[new_spot[0]][new_spot[1]] == "-" && possible_moves.include?(new_spot)
      return true
    elsif gamepiece.color == @board[new_spot[0]][new_spot[1]].color
      return false
    else
      return true
    end
  end

  # The castling must be kingside or queenside.
  # Neither the king nor the chosen rook has previously moved.
    # compare current king/rook location with the first location it should be at. (done)
      # b-king is at e-8, w-king is at e-1 (done)
      # w-rook is at a-1 and h-1, b-rook is at a-8 and h-8 (done)
  # There are no pieces between the king and the chosen rook. (done)
    # look at the 3(queenside) or 2(kingside) spaces for "-". (done)
      # use simulate movement? (done)
  # King may not castle out of, through, or into check.
    # Need to see if any pieces are being attacked by the enemy team.
      # Need to know enemies next possible moves. (done)
        # Data structure to hold this information. (array lol)
    # Check each of the pieces that are about to be traversed by the king. (done)
      # if they aren't, then castling is available. (done)
  # Implement the castling movement
    #queenside
      #white king goes from e1 --> c1
      #white rook goes from a1 --> d1
    #kingside
      #white king goes from e1 --> g1
      #white rook goes from h1 --> f1

  # Need to see if any pieces are being attacked by the enemy team.
    # Need to know enemies next possible moves. 
      # Check each enemy pieces possible moves. (done)
        # If king castles on to one of the possible moves, castling is not available.
        # Otherwise, castling is available, and can execute the castle.

  def enemy_moves(enemy_color)
    possible_moves = []
    @gamepieces[enemy_color].each_value do |piece_type|
      piece_type.each do |piece|
        next if piece.location == "dead"
        index = get_rank_and_file(piece.location)
        all_moves = gamepiece_moves(piece, index)
        all_moves.each do |move|
          chess_move = index_to_rank(move)
          possible_moves << move if valid_move?(piece, index, chess_move)
        end
      end
    end
    possible_moves
  end

  # Check each of the pieces that are about to be traversed by the king. 
    # if they aren't, then castling is available.
    # create a method that will take in a location and ally color, and check if it is being attacked by the enemy.
  def safe_location?(location, ally_color)
    enemy_color = ally_color == "white" ? "black" : "white"
    enemy_possible_moves = enemy_moves(enemy_color)
    if enemy_possible_moves.include?(location)
      return false
    else
      return true
    end
  end

  def safe_castle?(castle_type, king_color)
    if king_color == "white"
      if castle_type == "queenside"
        king_moves = ["e1", "d1", "c1"]
        king_moves.each do |move|
          index = get_rank_and_file(move)
          if safe_location?(index, king_color) == false
            return false
            break
          end
        end
        return true
      else
        king_moves = ["e1", "f1", "g1"]
        king_moves.each do |move|
          index = get_rank_and_file(move)
          if safe_location?(index, king_color) == false
            return false
            break
          end
        end
        return true
      end
    else
      if castle_type == "queenside"
        king_moves = ["e8", "d8", "c8"]
        king_moves.each do |move|
          index = get_rank_and_file(move)
          if safe_location?(index, king_color) == false
            return false
            break
          end
        end
        return true
      else
        king_moves = ["e8", "f8", "g8"]
        king_moves.each do |move|
          index = get_rank_and_file(move)
          if safe_location?(index, king_color) == false
            return false
            break
          end
        end
        return true
      end
    end
  end

  private

  def enemy_spot?(color, move)
    enemy_color = color == "white" ? "black" : "white"
    new_spot = @board[move[0]][move[1]]
    
    if new_spot.instance_of?(String)
      return false
    elsif new_spot.color == enemy_color
      return true
    end

  end

  def find_rank(num) #row
    @board.each_with_index do |row, idx|
      if row.first == num
        return idx
      end
    end
    return "invalid num"
  end

  def find_file(letter) #col
    @board[0].index(letter)
  end

  def index_to_rank(index) # rank = row; file = col
    @board[0][index[1]] + @board[index[0]].first
  end

  def add_gamepieces
    @gamepieces["white"].each_value do |value|
      value.each do |piece|
        change_board(piece.location, piece)
      end
    end

    @gamepieces["black"].each_value do |value|
      value.each do |piece|
        change_board(piece.location, piece)
      end
    end
  end

  def create_gamepieces
    @gamepieces["white"] = {
      "pawn" => [Pawn.new("white", "a2"), Pawn.new("white", "b2"), Pawn.new("white", "c2"), Pawn.new("white", "d2"), Pawn.new("white", "e2"), Pawn.new("white", "f2"), Pawn.new("white", "g2"), Pawn.new("white", "h2")],
      "knight" => [Knight.new("white", "b1"), Knight.new("white", "g1")],
      "rook" => [Rook.new("white", "a1"), Rook.new("white", "h1")],
      "bishop" => [Bishop.new("white", "c1"), Bishop.new("white", "f1")],
      "king" => [King.new("white")],
      "queen" => [Queen.new("white")]
     }

     @gamepieces["black"] = {
      "pawn" => [Pawn.new("black", "a7"), Pawn.new("black", "b7"), Pawn.new("black", "c7"), Pawn.new("black", "d7"), Pawn.new("black", "e7"), Pawn.new("black", "f7"), Pawn.new("black", "g7"), Pawn.new("black", "h7")],
      "knight" => [Knight.new("black", "b8"), Knight.new("black", "g8")],
      "rook" => [Rook.new("black", "a8"), Rook.new("black", "h8")],
      "bishop" => [Bishop.new("black", "c8"), Bishop.new("black", "f8")],
      "king" => [King.new("black")],
      "queen" => [Queen.new("black")]
     }
  end
 
  def change_board(coordinates, element)
    file = find_file(coordinates[0])
    rank = find_rank(coordinates[1])
    @board[rank][file] = element
  end

  def validate_bishop_move(bishop, index, move)
    row = move[0] - index[0]
    col = move[1] - index[1]
    if row.negative? && col.negative? #forward diagonal left [-1, -1]
      simulate_northwest_movement(row, col, index, bishop)
    elsif row.negative? && !col.negative? #forward diagonal right [-1, 1]
      simulate_northeast_movement(row, col, index, bishop)
    elsif !row.negative? && col.negative? #downward diagonal left [1, -1]
      simulate_southwest_movement(row, col, index, bishop)
    else #downward diagonal right [1,1]
      simulate_southeast_movement(row, col, index, bishop)
    end
  end

  def validate_rook_move(rook, index, move)
    row = move[0] - index[0]
    col = move[1] - index[1]
    if row.negative? && col == 0 #north [-1, 0]
      simulate_north_movement(row, col, index, rook)
    elsif !row.negative? && col == 0 #south [1, 0]
      simulate_south_movement(row, col, index, rook)
    elsif col.negative? && row == 0 #west [0, -1]
      simulate_west_movement(row, col, index, rook)
    else #east [0, 1]
      simulate_east_movement(row, col, index, rook)
    end
  end

  def validate_queen_king_move(gamepiece, index, move) 
    row = move[0] - index[0]
    col = move[1] - index[1]
    if row.negative? && col == 0 #north [-1, 0]
      simulate_north_movement(row, col, index, gamepiece)
    elsif !row.negative? && col == 0 #south [1, 0]
      simulate_south_movement(row, col, index, gamepiece)
    elsif col.negative? && row == 0 #west [0, -1]
      simulate_west_movement(row, col, index, gamepiece)
    elsif !col.negative? && row == 0 #east [0, 1]
      simulate_east_movement(row, col, index, gamepiece)
    elsif row.negative? && col.negative? #forward diagonal left [-1, -1]
      simulate_northwest_movement(row, col, index, gamepiece)
    elsif row.negative? && !col.negative? #forward diagonal right [-1, 1]
      simulate_northeast_movement(row, col, index, gamepiece)
    elsif !row.negative? && col.negative? #downward diagonal left [1, -1]
      simulate_southwest_movement(row, col, index, gamepiece)
    else #downward diagonal right [1,1]
      simulate_southeast_movement(row, col, index, gamepiece)
    end
  end

  #pawn's move are one move forward unless it is first turn (2 moves forward) or they are attacking (forward diagonal)
  def validate_pawn_move(pawn, index, move)
   
    if enemy_spot?(pawn.color, move)
      row = move[0] - index[0]
      col = move[1] - index[1]
      if [row, col] == [1, 0] || [row, col] == [-1, 0]
        return false
      end
    end

    row = move[0] - index[0]
    col = move[1] - index[1]
    if pawn.color == "white"
      simulate_north_movement(row, col, index, pawn)
    else 
      simulate_south_movement(row, col, index, pawn)
    end
  end

  def simulate_northwest_movement(row, col, index, gamepiece)
    # From starting location UP to final location, this checks to see if there are any enemy pieces or ally pieces in the way.
    # If there are, it will return false, and the movement is not valid
    # If we just need to move one spot, then we need a separate case because the range will not include 1 using ... when the condition is 1...1
    # 1...1 goes from 1 up to and not including 1 therefore.
    if row == -1
      new_row = index[0] - 1
      new_col = index[1] - 1
      if @board[new_row][new_col] == "-"
        return true
      #If there is an ally on the spot, return false; Invalid move.
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      #Else, the spot is nothing or it is an enemy; Valid move.
      else
        return true
      end
    end
    
    (1...row.abs).each do |num|
      new_row = index[0] - num
      new_col = index[1] - num
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    # Need to check if the final location is an enemy. If it is, then the move is valid, and can execute removal of enemy piece.
    true
  end

  def simulate_northeast_movement(row, col, index, gamepiece)
    if row == -1
      new_row = index[0] - 1
      new_col = index[1] + 1
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...row.abs).each do |num|
      new_row = index[0] - num
      new_col = index[1] + num
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
  end

  def simulate_southwest_movement(row, col, index, gamepiece)
    if row == 1
      new_row = index[0] + 1
      new_col = index[1] - 1
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...row.abs).each do |num|
      new_row = index[0] + num
      new_col = index[1] - num
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
  end

  def simulate_southeast_movement(row, col, index, gamepiece)
    if row == 1
      new_row = index[0] + 1
      new_col = index[1] + 1
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...row.abs).each do |num|
      new_row = index[0] + num
      new_col = index[1] + num
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
  end

  def simulate_north_movement(row, col, index, gamepiece)
    if row == -1
      new_row = index[0] - 1
      new_col = index[1]
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...row.abs).each do |num|
      new_row = index[0] - num
      new_col = index[1]
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
  end

  def simulate_south_movement(row, col, index, gamepiece)
    if row == 1
      new_row = index[0] + 1
      new_col = index[1]
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...row.abs).each do |num|
      new_row = index[0] + num
      new_col = index[1]
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
  end

  def simulate_east_movement(row, col, index, gamepiece)
    if col == 1
      new_row = index[0]
      new_col = index[1] + 1
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...col.abs).each do |num|
      new_row = index[0]
      new_col = index[1] + num
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
  end

  def simulate_west_movement(row, col, index, gamepiece)
    if col == -1
      new_row = index[0]
      new_col = index[1] - 1
      if @board[new_row][new_col] == "-"
        return true
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return true
      end
    end

    (1...col.abs).each do |num|
      new_row = index[0]
      new_col = index[1] - num
      if @board[new_row][new_col] == "-"
        next
      elsif gamepiece.color == @board[new_row][new_col].color
        return false
      else
        return false
      end
    end
    true
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

  # The capturing pawn must be on its fifth rank;
  # The capture can only be made on the move immediately after the enemy pawn makes the double-step move; 
  # Otherwise, the right to capture it en passant is lost.
  def en_passant?(capturing_pawn)
    #The capturing pawn must be on its fifth rank
    current_location = get_rank_and_file(capturing_pawn.location)
    first_location = get_rank_and_file(capturing_pawn.game_moves[0])
    #The captured pawn must be on an adjacent file and must have just moved two squares in a single move (i.e. a double-step move);
    if (current_location[0] - first_location[0]).abs == 3
      left_spot = @board[current_location[0]][current_location[1] - 1]
      right_spot = @board[current_location[0]][current_location[1] + 1]
      if !left_spot.instance_of?(String) && left_spot.name == "P"
        if left_spot.game_moves.length == 2
          return left_spot.location 
        else
          return false
        end
      elsif !right_spot.instance_of?(String) && right_spot.name == "P"
        if right_spot.game_moves.length == 2
          return right_spot.location
        else
          return false
        end
      else
        false
      end
    else
      return false
    end
  end

end