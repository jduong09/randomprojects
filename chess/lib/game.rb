require_relative "board.rb"
require_relative "player.rb"

Dir["/game_pieces/*.rb"].each {|file| require file }

class Game
  def initialize
    @board = Board.new
    @players = []
    @turn = 0
  end

  def game_start
    puts "Welcome to Chess! This game will require 2 players, so let us assign those players now!"
    assign_players
    assign_colors
    @board.fill_board
  end

  # White moves first.
  def game_loop
    game_start
    loop do
      current_player = @players[@turn % 2]
      take_turn(current_player)

      @turn += 1
    end
  end

  #take_turn should take the current player as the input. 
  # we send what gamepiece color's turn it is. 
  #should ask for which gamepiece the player wants to move. (done)
  #should validate that the input is correct. (done)
  #should ask for which gamepiece the player wants to place the chesspiece (done)
  #should validate that is correct.
    #check if move can be made from all possible gamepiece moves. (done)
    #check if move puts the gamepiece on a ally gamepiece (should not be able to do that) (done)
    #check if move takes an enemies gamepiece (place, and remove enemies gamepiece from game.) (done)
    #check if move places ally king in check (cannot make that move)
  #make the change, move the gamepiece
    #remove gamepiece if necessary
    #old spot becomes blank
    #check if move places enemy king in check
  def take_turn(player)
    puts "#{player.name}, it is your turn."
    loop do
      gamepiece = turn_start(player)
      index = @board.get_rank_and_file(gamepiece.location)
      move = turn_move(gamepiece, index)
      redo if move == false

      execute_move(gamepiece, move)
      
      #If pawn has reached last rank, promote to new gamepiece of user's choice.
      if gamepiece.name == "P" && @board.promote_pawn?(gamepiece)
        location = gamepiece.location
        puts "Your pawn has reached promotion rank. Type the gamepiece you want to promote your pawn to. ex: 'Q'"
        new_piece = gets.chomp
        @board.promote(gamepiece, new_piece)
        new_gamepiece = @board.find_gamepiece(location)
        puts "Check" if @board.check?(new_gamepiece)
        return @board.display_board
      end

      puts "Check" if @board.check?(gamepiece)
      return @board.display_board
    end
  end

  def turn_start(player)
    loop do
      puts "Choose the piece you want to move by typing the location of the piece. ex: a1"
      location = gets.chomp
      gamepiece = @board.find_gamepiece(location)

      if gamepiece.nil? || gamepiece == "-" || correct_color?(player, gamepiece) == false
        puts "Incorrect location of piece. Choose again."
      elsif @board.possible_moves?(gamepiece) == false
        puts "This gamepiece has no available moves."
      else
        return gamepiece
      end
    end
  end

  def turn_move(gamepiece, index)
    loop do
      puts "Where do you want your #{gamepiece.icon} to go?"
      puts "Type 'reselect' if you want to choose a different gamepiece to move."
      new_location = gets.chomp
      
      return false if new_location == "reselect"

      return new_location if @board.valid_move?(gamepiece, index, new_location) 
    end
  end

  def execute_move(gamepiece, move)
    if @board.find_gamepiece(move) == "-"
      @board.move_gamepiece(gamepiece.location, move, gamepiece)
    else
      @board.remove_gamepiece(gamepiece, move)
      @board.move_gamepiece(gamepiece.location, move, gamepiece)
    end
  end

  private

  def assign_players
    puts "The white piece goes first in traditional chess. Player 1 will be the white piece."
    2.times do |num|
      puts "What is player #{num + 1}'s name?"
      name = gets.chomp
      create_player(name)
    end
  end

  def correct_color?(player, gamepiece)
    if gamepiece.color == player.color
      true
    else
      puts "This is the enemies piece."
      false
    end
  end

  def create_player(name)
    @players << Player.new(name)
  end

  def assign_colors
    @players[0].assign_color("white")
    @players[1].assign_color("black")
  end

end