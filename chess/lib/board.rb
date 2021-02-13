require_relative "game_pieces/bishop.rb"
require_relative "game_pieces/king.rb"
require_relative "game_pieces/knight.rb"
require_relative "game_pieces/pawn.rb"
require_relative "game_pieces/queen.rb"
require_relative "game_pieces/rook.rb"

#2/11/20 schedule
# handle all the movement of the characters
# handle check/checkmate
# game_loop

class Board
  attr_accessor :board
  attr_accessor :gamepieces

  def initialize
    @board = Array.new(8) { Array.new(8) {"-"} }
    @gamepieces = {}
  end

  def take_turn(color)
    puts "It is your turn. Choose the piece you want to move by typing the location of the piece."
    type = gets.chomp
    input = gets.chomp
    col = find_file(input[0])
    row = find_rank(input[1])
  
    piece = @gamepieces[color][type].select { |piece| piece.location == input }

    puts "Where do you want your #{piece[0].icon} to go?"
    new_location = gets.chomp
    possible_moves = gamepiece_moves(piece[0], [row, col])

    piece[0].change_location(new_location) if possible_moves.include?(new_location)
    change_board(new_location, piece[0].icon)
    change_board(input, "-")
    display_board
  end
  #castling. Separate method?
  def gamepiece_moves(gamepiece, input)
    all_moves = gamepiece.moves(input)
    all_moves.map do |move|
      index_to_rank(move)
    end
    #puts "Where do you want your #{gamepiece.icon} to go?"
    #user_input = gets.chomp
    #row = find_rank(input[1])
    #col = find_file(input[0])

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

  def [](col, row)
    @board[row][col]
  end

  private

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
    #board coordinates are "letter num"
    #finding the right file and rank given the index coordinates, and then returning the spot in chess terms.
    # "col row"
    @board[0][index[1]] + @board[index[0]].first
  end

  def add_gamepieces
    @gamepieces["white"].each_value do |value|
      value.each do |piece|
        change_board(piece.location, piece.icon)
      end
    end

    @gamepieces["black"].each_value do |value|
      value.each do |piece|
        change_board(piece.location, piece.icon)
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

  def display_board
    string = ""
    @board.each do |row|
      row_string = ""
      row.each do |col|
        row_string += col + " "
      end
      row_string += "\n"
      string += row_string
    end
    puts string
  end
 
  def change_board(coordinates, element)
    file = find_file(coordinates[0])
    rank = find_rank(coordinates[1])
    @board[rank][file] = element
  end
  
end

