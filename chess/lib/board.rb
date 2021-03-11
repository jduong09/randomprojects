require_relative "game_pieces/bishop.rb"
require_relative "game_pieces/king.rb"
require_relative "game_pieces/knight.rb"
require_relative "game_pieces/pawn.rb"
require_relative "game_pieces/queen.rb"
require_relative "game_pieces/rook.rb"

class Board
  attr_accessor :board, :gamepieces

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
 
  #Run the gamepieces moves method, which returns all available moves based on the gamepiece.
  #Validate each move in respect to the board
  #Returns empty array if no available moves.
  def gamepiece_moves(gamepiece, index)
    all_moves = gamepiece.moves(index)

    if gamepiece.name == "N"
      knight_moves = []
      all_moves.each do |move|
        knight_moves << move if validate_knight_move(gamepiece, index, move)
      end
      return knight_moves
    end

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
        king_index = get_rank_and_file(gamepiece.location)
        if gamepiece.color == "white" 
          king_moves << [8,3] unless simulate_west_movement(0, 4, king_index, gamepiece) == false || safe_castle?("queenside", gamepiece.color) == false
          king_moves << [8,7] unless simulate_east_movement(0, 3, king_index, gamepiece) == false || safe_castle?("kingside", gamepiece.color) == false
        else 
          king_moves << [1,3] unless simulate_west_movement(0, 4, king_index, gamepiece) == false || safe_castle?("queenside", gamepiece.color) == false
          king_moves << [1,7] unless simulate_east_movement(0, 3, king_index, gamepiece) == false || safe_castle?("kingside", gamepiece.color) == false
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
        enemy = en_passant?(gamepiece)

        enemy_index = get_rank_and_file(enemy.location)
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

    old_location_index = get_rank_and_file(old_location)
    row = new_spot[0] - old_location_index[0]
    col = new_spot[1] - old_location_index[1]
    # add that new location has to be diagonal to the P's.
    if ([row, col] == [1,1] || [row, col] == [-1,-1] || [row, col] == [-1, 1] || [row, col] == [1, -1]) && en_passant?(gamepiece) != false
      dead_gamepiece = en_passant?(gamepiece)
      old_spot = dead_gamepiece.location
      remove_gamepiece(gamepiece, dead_gamepiece.location)
      change_board(old_spot, "-")
    end

    # Implement the castling movement
    if gamepiece.name == "K" 
      if gamepiece.color == "white"
        if new_location == "c1"
          rook = @gamepieces[gamepiece.color]["rook"][0]
          execute_castling(gamepiece, rook, "c1", "d1")
        end

        if new_location == "g1"
          other_rook = @gamepieces[gamepiece.color]["rook"][1]
          execute_castling(gamepiece, other_rook, "g1", "f1")
        end
      end

      if gamepiece.color == "black"
        if new_location == "c8"
          rook = @gamepieces[gamepiece.color]["rook"][0]
          execute_castling(gamepiece, rook, "c8", "d8")
        end

        if new_location == "g8"
          other_rook = @gamepieces[gamepiece.color]["rook"][1]
          execute_castling(gamepiece, other_rook, "g8", "f8")
        end

      end
    end
    change_board(old_location, "-")
    change_board(new_location, gamepiece)
    gamepiece.change_location(new_location)
  end

  def remove_gamepiece(gamepiece, move)
    dead_gamepiece = find_gamepiece(move)
    dead_gamepiece.change_location("dead")
  end

  #Takes in the gamepiece that is being moved, and the current location of the gamepiece as an index, 
  #Also takes in new location that the gamepiece wants to be moved in, in rank/file notation
  #Making sure it is either in an open spot, or takes an enemy spot.
  #Therefore, make sure it is in the possible move array and that it doesn't land onto an ally spot.

  #should validate that is correct.
    #check if move can be made from all possible gamepiece moves. (done)
    #check if move puts the gamepiece on a ally gamepiece (should not be able to do that) (done)
    #check if move takes an enemies gamepiece (place, and remove enemies gamepiece from game.) (done)
    #check if move places ally king in check (cannot make that move)
      # Simulate the new board if the move were to be made. 
      # Look at enemies moves, and see if they can place in check 
        # This would mean enemy would get take king next turn. 

  def valid_move?(gamepiece, index, new_location)
    possible_moves = gamepiece_moves(gamepiece, index)
    return false if possible_moves.empty?

    new_spot = get_rank_and_file(new_location)

    if simulate_next_move(gamepiece, new_location) == false
      puts "That move puts your king in check."
      return false
    end

    if !possible_moves.include?(new_spot)
      puts "That move is impossible for #{gamepiece.icon}."
      return false
    elsif simulate_next_move(gamepiece, new_location) == false
      puts "That move puts your king in check."
      return false
    elsif @board[new_spot[0]][new_spot[1]] == "-" && possible_moves.include?(new_spot)
      return true
    elsif gamepiece.color == @board[new_spot[0]][new_spot[1]].color
      return false
    else
      return true
    end

  end

  def enemy_moves(enemy_color)
    possible_moves = []
    @gamepieces[enemy_color].each_value do |piece_type|
      piece_type.each do |piece|
        next if piece.location == "dead"
        index = get_rank_and_file(piece.location)
        all_moves = gamepiece_moves(piece, index)
        all_moves.each do |move|
          chess_move = index_to_rank(move)
          possible_moves << move
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

  def possible_moves?(gamepiece)
    index = get_rank_and_file(gamepiece.location)
    if gamepiece_moves(gamepiece, index).empty?
      return false
    else
      return true
    end
  end

  # The object of the game is to checkmate the opponent; this occurs when the opponent's king is in check,
  # and there is no legal way to remove it from attack.
  # It is never legal for a player to make a move that puts or leaves the player's own king in check. 
  def check?(gamepiece)
    enemy_color = gamepiece.color == "white" ? "black" : "white"
    enemy_king = @gamepieces[enemy_color]["king"][0]
    gamepiece_index = get_rank_and_file(gamepiece.location)
    enemy_king_index = get_rank_and_file(enemy_king.location)
    next_moves = gamepiece_moves(gamepiece, gamepiece_index)

    if next_moves.include?(enemy_king_index)
      return true
    else
      return false
    end
  end

  # When a player is in check, and he cannot make a move such that after the move, the king is not in check, then he is mated. 
  # Note that there are three different possible ways to remove a check:
    # Move the king away to a square where he is not in check.
    # Take the piece that gives the check.
    # (In case of a check, given by a rook, bishop or queen: ) move a piece between the checking piece and the king.

  #Implementation
    #Take a look at your moves. If enemy king is in these moves, he is in check. (done)
      #If the king's next moves still can be attacked by the enemies, he cannot move. (he is in checkmate)
      #If you cannot take out the pieces that gives check, he is still in checkmate.
      #If you cannot put a piece between the checking piece and the king, he is in checkmate.
  def checkmate?(gamepiece)
    if check?(gamepiece)
      enemy_color = gamepiece.color == "white" ? "black" : "white"
      enemy_king = @gamepieces[enemy_color]["king"][0]
      enemy_king_index = get_rank_and_file(enemy_king.location)
      enemy_king_moves = gamepiece_moves(enemy_king, enemy_king_index)
      gamepiece_index = get_rank_and_file(gamepiece.location)
      
      if enemy_king_moves.empty? #If the king has no moves, he cannot move, is still in check.
        #Must have a enemy move that can take out the piece that gives check,
        enemy_moves = enemy_moves(enemy_color)
        if enemy_moves.include?(gamepiece_index)
          return false
        end

        #Or cannot put a piece between the checking piece and the king, he is in checkmate. Only cases if the gamepiece is a Bishop, Queen or Rook
        if gamepiece.name == "B" || gamepiece.name == "Q" || gamepiece.name == "R"
          gamepiece_next_moves = gamepiece_moves(gamepiece, gamepiece_index)
          gamepiece_next_moves.each do |move|
            if enemy_moves.include?(move)
              return false
            end
          end
        end
      else
      
        enemy_king_moves.each do |move|
          if safe_location?(move, enemy_color)
            return false
          end
        end

      end
      #No way to get enemy king out of check.
      #Return true, enemy king is in checkmate.
      return true
      
    else
      return false
    end
  end

  # Pawns that reach the last row of the board promote. 
  # When a player moves a pawn to the last row of the board, he replaces the pawn by a queen, rook, knight, or bishop (of the same color). 
  # Usually, players will promote the pawn to a queen, but the other types of pieces are also allowed. 
  # (It is not required that the pawn is promoted to a piece taken. 
  # Thus, it is for instance possible that a player has at a certain moment two queens.)

  def promote_pawn?(pawn)
    first_location_index = get_rank_and_file(pawn.game_moves[0])
    current_location_index = get_rank_and_file(pawn.location)
    if (current_location_index[0] - first_location_index[0]).abs == 6
      return true
    else
      return false
    end
  end

  def promote(pawn, new_gamepiece)
    location = pawn.location

    if new_gamepiece == "Q"
      new_queen = Queen.new(pawn.color, pawn.location)
      remove_gamepiece(pawn, pawn.location)
      change_board(location, new_queen)
    elsif new_gamepiece == "B"
      new_bishop = Bishop.new(pawn.color, pawn.location)
      remove_gamepiece(pawn, pawn.location)
      change_board(location, new_bishop)
    elsif new_gamepiece == "R"
      new_rook = Rook.new(pawn.color, pawn.location)
      remove_gamepiece(pawn, pawn.location)
      change_board(location, new_rook)
    else # new_gamepiece == "N"
      new_knight = Knight.new(pawn.color, pawn.location)
      remove_gamepiece(pawn.color, pawn.location)
      change_board(location, new_knight)
    end
  end

  def simulate_next_move(gamepiece, new_location)
    old_location = gamepiece.location
    new_location_index = get_rank_and_file(new_location)

    if gamepiece.name == "P" && en_passant?(gamepiece) != false
      enemy_gamepiece = en_passant?(gamepiece)
      old_enemy_location = enemy_gamepiece.location

      move_gamepiece(gamepiece.location, new_location, gamepiece)
      ally_king_location = get_rank_and_file(@gamepieces[gamepiece.color]["king"][0].location)

      if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
        gamepiece.game_moves.pop
      end

      if safe_location?(ally_king_location, gamepiece.color) == false
        enemy_gamepiece.change_location(old_enemy_location)
        change_board(old_location, gamepiece)
        change_board(new_location, "-")
        gamepiece.change_location(old_location)
        
        
        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        change_board(old_enemy_location, enemy_gamepiece)

        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
          gamepiece.game_moves.pop
        end

        return false
      else
        enemy_gamepiece.change_location(old_enemy_location)
        change_board(old_location, gamepiece)
        change_board(new_location, "-")
        gamepiece.change_location(old_location)

        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        change_board(old_enemy_location, enemy_gamepiece)
          
        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
          gamepiece.game_moves.pop
        end

        return true
      end
    end

    if enemy_spot?(gamepiece.color, new_location_index)
      enemy_gamepiece = find_gamepiece(new_location)
      old_enemy_location = enemy_gamepiece.location
      remove_gamepiece(enemy_gamepiece, new_location)

      move_gamepiece(gamepiece.location, new_location, gamepiece)
      ally_king_location = get_rank_and_file(@gamepieces[gamepiece.color]["king"][0].location)

      if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
        gamepiece.game_moves.pop
      end

      if safe_location?(ally_king_location, gamepiece.color) == false
        enemy_gamepiece.change_location(old_enemy_location)
        change_board(old_location, gamepiece)
        change_board(new_location, "-")
        gamepiece.change_location(old_location)
        
        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        change_board(new_location, enemy_gamepiece)

        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
          gamepiece.game_moves.pop
        end

        return false
      else
        enemy_gamepiece.change_location(old_enemy_location)
        change_board(old_location, gamepiece)
        change_board(new_location, "-")
        gamepiece.change_location(old_location)

        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        change_board(new_location, enemy_gamepiece)
          
        if enemy_gamepiece.name == "P" || enemy_gamepiece.name == "R" || enemy_gamepiece.name == "K"
          enemy_gamepiece.game_moves.pop
        end

        if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
          gamepiece.game_moves.pop
        end

        return true
      end

    end

    move_gamepiece(gamepiece.location, new_location, gamepiece)
    ally_king_location = get_rank_and_file(@gamepieces[gamepiece.color]["king"][0].location)

    if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
      gamepiece.game_moves.pop
    end

    #if gamepiece just goes to a "-" location
    if safe_location?(ally_king_location, gamepiece.color) == false
      change_board(old_location, gamepiece)
      change_board(new_location, "-")
      gamepiece.change_location(old_location)
      if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
        gamepiece.game_moves.pop
      end
      return false
    else
      change_board(old_location, gamepiece)
      change_board(new_location, "-")
      gamepiece.change_location(old_location)
      if gamepiece.name == "P" || gamepiece.name == "R" || gamepiece.name == "K"
        gamepiece.game_moves.pop
      end
      return true
    end

  end

  #private

  def enemy_spot?(color, move)
    new_spot = @board[move[0]][move[1]]
    
    if new_spot.instance_of?(String)
      return false
    elsif new_spot.color == color
      return false
    else
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
      "queen" => [Queen.new("white", "d1")]
     }

     @gamepieces["black"] = {
      "pawn" => [Pawn.new("black", "a7"), Pawn.new("black", "b7"), Pawn.new("black", "c7"), Pawn.new("black", "d7"), Pawn.new("black", "e7"), Pawn.new("black", "f7"), Pawn.new("black", "g7"), Pawn.new("black", "h7")],
      "knight" => [Knight.new("black", "b8"), Knight.new("black", "g8")],
      "rook" => [Rook.new("black", "a8"), Rook.new("black", "h8")],
      "bishop" => [Bishop.new("black", "c8"), Bishop.new("black", "f8")],
      "king" => [King.new("black")],
      "queen" => [Queen.new("black", "d8")]
     }
  end
 
  def change_board(coordinates, element)
    file = find_file(coordinates[0])
    rank = find_rank(coordinates[1])
    @board[rank][file] = element
  end

  def validate_knight_move(knight, index, move)
    if @board[move[0]][move[1]] == "-"
      return true
    elsif knight.color == @board[move[0]][move[1]].color
      return false
    else
      return true
    end
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
      elsif [row, col] == [2,0] || [row, col] == [-2, 0]
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
    #The capturing pawn must be on its fifth rank
    if (current_location[0] - first_location[0]).abs == 3 
      left_spot = @board[current_location[0]][current_location[1] - 1]
      right_spot = @board[current_location[0]][current_location[1] + 1]

      if left_spot == nil && adjacent_pawn?(right_spot)
        if right_spot.game_moves.length == 2
          return right_spot 
        else
          return false
        end
      end

      if right_spot == nil && adjacent_pawn?(left_spot)
        if left_spot.game_moves.length == 2
          return left_spot 
        else
          return false
        end
      end
      
      if adjacent_pawn?(left_spot)
        if left_spot.game_moves.length == 2
          return left_spot
        else
          return false
        end
      elsif adjacent_pawn?(right_spot)
        if right_spot.game_moves.length == 2
          return right_spot 
        else
          return false
        end
      else
        return false
      end

    else
      return false
    end
  end

  def adjacent_pawn?(spot)
    
    if !spot.instance_of?(String) && spot.name == "P"
      return true
    else
      return false
    end
  end

#Once in every game, each king can make a special move, known as castling. Castling consists of moving the king two squares along the first rank toward a rook on the player's first rank, and then placing the rook on the last square that the king crossed. Castling is permissible if the following conditions are met:[1]
  #Neither the king nor the rook has previously moved during the game.
  #There are no pieces between the king and the rook.
  #The king is not in check, and will not pass through or land on any square attacked by an enemy piece. (Note that castling is permitted if the rook is under attack, or if the rook crosses an attacked square.)
  def castling?(king)
    if king.color == "white"
      return false if king.game_moves.length != 1
      king_index = get_rank_and_file(king.location)
      if @gamepieces[king.color]["rook"][0].location == "a1"
        return false if simulate_west_movement(0, 4, king_index, king) == false
        return false if safe_castle?("queenside", king.color) == false
        return true if safe_castle?("queenside", king.color)
      elsif @gamepieces[king.color]["rook"][1].location == "h1"
        return false if simulate_east_movement(0, 3, king_index, king) == false
        return false if safe_castle?("kingside", king.color) == false
        return true if safe_castle?("kingside", king.color)
      else
        return false
      end
    elsif king.color == "black"
      return false if king.game_moves != 1
      king_index = get_rank_and_file(king.location)
      if @gamepieces[king.color]["rook"][0].location == "a8"
        return false if simulate_west_movement(0, 4, king_index, king) == false
        return false if safe_castle?("queenside", king.color) == false
        return true if safe_castle?("queenside", king.color)
      elsif @gamepieces[king.color]["rook"][1].location == "h8"
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

  def execute_castling(king, rook, new_king_spot, new_rook_spot)
    change_board(king.location, "-")
    change_board(new_king_spot, king)
    change_board(rook.location, "-")
    change_board(new_rook_spot, rook)
    king.change_location(new_king_spot)
    rook.change_location(new_rook_spot)
  end

end