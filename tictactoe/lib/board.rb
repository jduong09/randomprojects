require_relative './cell.rb'
require_relative './player.rb'

class Board
  attr_accessor :board, :players

  def initialize
    #create a 3 x 3 array. 
    @rows = 3
    @columns = 3
    @board = Array.new(@rows) { Array.new(@columns) { Cell.new } }
    @players = []
  end

  def play_game
    game_intro  
    display_board
    game_loop
  end

  def game_over?
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

  def game_intro
    puts "Welcome to Tic-tac-toe"
    puts "What is the first player's name?"
    name_1 = player_input
    puts "What is the first player's marker?"
    marker_1 = player_input
    player_1 = create_player(name_1, marker_1)
    puts "What is the second player's name?"
    name_2 = player_input
    puts "What is the second player's marker?"
    marker_2 = player_input
    player_2 = create_player(name_2, marker_2)
  end

  def player_input 
    gets.chomp
  end

  def create_player(player, marker)
    new_player = Player.new(player, marker)
    @players << new_player
  end

  def game_loop
    9.times do |turn|
      turn_order(turn)
      if game_over?
        display_board
        return "Game Over!"
      end
      display_board
    end
  end

  def turn_order(turn_number)
    current_player = @players[turn_number % 2]
    take_turn(current_player)
  end

  def take_turn(player) 
    loop do
      coordinates = player.move
      if verify_guess(coordinates)
        row = coordinates[0]
        col = coordinates[1]
        self[row, col].change_value(player.marker)
        break
      end
    end
  end

  def [](row, column)
    @board[row][column]
  end

  def verify_guess(move)
    if self[move[0], move[1]].value != "-"
      puts "This spot has been taken on the board; Please choose again:"
      return false
    end
    true
  end
end
