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

  #castling. Separate method?
  def gamepiece_moves(gamepiece, input)
    all_moves = gamepiece.moves(input)

    coordinates = all_moves.map { |move| index_to_rank(move) } 
    
    if gamepiece.name == "P" 
      if gamepiece.color == "white"
        directions = [[-1, -1], [-1, 1]]
        directions.each do |direction|
          row = input[0] + direction[0]
          col = input[1] + direction[1]
          move = index_to_rank([row, col])
          coordinates << move if enemy_spot?(gamepiece.color, move)
        end
      elsif gamepiece.color == "black"
        directions = [[1, -1], [1, 1]]
        directions.each do |direction|
          row = input[0] + direction[0]
          col = input[1] + direction[1]
          move = index_to_rank([row, col])
          coordinates << move if enemy_spot?(gamepiece.color, move)
        end
      end
    end
    coordinates
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

    #knight can jump over pieces, therefore it's movement is as simple as these two lines.
    change_board(old_location, "-")
    change_board(new_location, gamepiece)

    #rook, bishop and queen can move infinitely in one direction
    #but if there is an ally in between it must be stopped.
    display_board
  end

  def remove_gamepiece(gamepiece, move)
    dead_gamepiece = find_gamepiece(move)
    move_gamepiece(gamepiece.location, move, gamepiece)
    gamepiece.change_location(move)
    dead_gamepiece.change_location("dead")
    
    display_board
  end

  #Takes in the gamepiece that is being moved, and the current location of the gamepiece as an index, 
  #Also takes in new location that the gamepiece wants to be moved in, in rank/file notation
  #Making sure it is either in an open spot, or takes an enemy spot.
  #Therefore, make sure it is in the possible move array and that it doesn't land onto an ally spot.
  def valid_move?(gamepiece, index, new_location)
    possible_moves = gamepiece_moves(gamepiece, index)
    new_spot = get_rank_and_file(new_location)

    #checks for if there is a unit in front of the pawn, which doesn't allow the pawn to move forward.
    if gamepiece.name == "P" && enemy_spot?(gamepiece.color, new_location)
      row = new_spot[0] - index[0]
      col = new_spot[1] - index[1]
      if [row, col] == [1, 0] || [row, col] == [-1, 0]
        puts "That move is not possible for the pawn."
        return false
      end
    end

    if @board[new_spot[0]][new_spot[1]] == "-" && possible_moves.include?(new_location)
      return true
    elsif !possible_moves.include?(new_location)
      puts "That move is impossible for #{gamepiece.icon}."
      return false
    elsif gamepiece.color == @board[new_spot[0]][new_spot[1]].color
      puts "Placement of gamepiece on ally piece. Select a valid location for your #{gamepiece.icon}."
      return false
    else
      return true
    end
  end

  def enemy_spot?(color, move)
    index = get_rank_and_file(move)
    enemy_color = color == "white" ? "black" : "white"
    new_spot = @board[index[0]][index[1]]
    
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

end