require_relative "knight"

class Board
  def initialize
    @board = Array.new(8) { Array.new(8) {"-"} }
  end

  def move_gamepiece(gamepiece, move)
    
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

  #def fillBoard
    #black_knight = Knight.new([7, 1])
  #end
end

