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
    #check if move puts the gamepiece on a ally gamepiece (should not be able to do that)
    #check if move takes an enemies gamepiece (place, and remove enemies gamepiece from game.)
  #make the change, move the gamepiece
    #remove gamepiece if necessary
    #old spot becomes blank
  def take_turn(player)
    gamepiece = turn_start(player)
    index = @board.get_rank_and_file(gamepiece.location)
    move = turn_move(gamepiece, index)
    execute_move(gamepiece, move)
  end

  def turn_start(player)
    loop do
      puts "#{player.name}, it is your turn."
      puts "Choose the piece you want to move by typing the location of the piece. ex: a1"
      location = gets.chomp
      gamepiece = @board.find_gamepiece(location)

      return gamepiece unless gamepiece.nil? || gamepiece == "-" || correct_color?(player, gamepiece) == false

      puts "Incorrect location of piece. Choose again."
    end
  end

  def turn_move(gamepiece, index)
    loop do
      puts "Where do you want your #{gamepiece.icon} to go?"
      new_location = gets.chomp

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

game = Game.new
game.game_loop