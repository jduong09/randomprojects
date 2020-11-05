require_relative './cell.rb'
require_relative './player.rb'

class Board
  attr_accessor :board

  def initialize(rows, columns)
    #create a 3 x 3 array. 
    @rows = rows
    @columns = columns
    @board = Array.new(@rows) { Array.new(@columns) { Cell.new } }
    @players = []
  end

  def [](row, column)
    @board[row][column]
  end

  def play_game
    puts "Welcome to Tic-tac-toe"
    puts "What is player 1's name?"
    player_1 = gets.chomp
    puts "What is player 1's marker?"
    marker_1 = gets.chomp
    puts "What is player 2's name?"
    player_2 = gets.chomp
    puts "What is player 2's marker?"
    marker_2 = gets.chomp
    @players << Player.new(player_1, marker_1)
    @players << Player.new(player_2, marker_2)
    self.display_board

    #looking to loop 9 times, bc theres 9 turns. each turn, the current player will be the next player. 
    (@rows * @columns).times do |turn|
      current_turn = turn % 2
      current_player = @players[current_turn]
      self.take_turn(current_player)
      if self.game_over?
        self.display_board
        return "Game Over!"
      end
      self.display_board
    end
    puts "It's a tie!"
  end

  def game_over?
    # if a row or column, or diagonal (2 diagonals) are the same, then win is true.
    # how to code this?
    # check each possibilities (8)
    if self[0,0].value == self[0,1].value && self[0,0].value == self[0,2].value
      winning_marker = self[0,0].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[1,0].value == self[1,1].value && self[1,0].value == self[1,2].value
      winning_marker = self[1,0].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[2,0].value == self[2,1].value && self[2,0].value == self[2,2].value
      winning_marker = self[2,0].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[0,0].value == self[1,0].value && self[0,0].value == self[2,0].value
      winning_marker = self[0,0].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[0,1].value == self[1,1].value && self[0,1].value == self[2,1].value
      winning_marker = self[0,1].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[0,2].value == self[1,2].value && self[0,2].value == self[2,2].value
      winning_marker = self[0,2].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[0,0].value == self[1,1].value && self[0,0].value == self[2,2].value
      winning_marker = self[0,0].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    elsif self[0,2].value == self[1,1].value && self[0,2].value == self[2,0].value
      winning_marker = self[0,2].value
      if @players[0].marker == winning_marker
        puts "#{@players[0].name} wins!"
        return true
      elsif @players[1].marker == winning_marker
        puts "#{@players[1].name} wins!"
        return true
      end
    end
    return false
  end

  def take_turn(player)
    coordinates = player.move
    # need to check if  the move has already been played. Check if the value at that cell is "". if it is, then go ahead and make the move. if it isn't, then the move has been done. 
    while spot_taken?(coordinates) == false
      puts "This spot has been taken on the board; Please choose again:"
      coordinates = player.move
    end
    row = coordinates[0]
    col = coordinates[1]
    self[row, col].change_value(player.marker)
  end

  def display_board
    string = ""
    @board.each do |row|
      row_string = ""
      row.each do |col|
        row_string += col.value + " "
      end
      row_string += "\n"
      string += row_string
    end
    puts string
  end

  def spot_taken?(move)
    if self[move[0], move[1]].value != "-"
      return false
    end
    true
  end
end