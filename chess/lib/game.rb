require_relative "board.rb"
require_relative "player.rb"

Dir["/game_pieces/*.rb"].each {|file| require file }

class Game
  def initialize
    @board = Board.new
    @players = []
  end

  def game_start
    puts "Welcome to Chess! This game will require 2 players, so let us assign those players now!"
    assign_players
    @board.fill_board
  end

  def game_loop
    take_turn
  end

  def take_turn(color)
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

    gamepiece = turn_start
    index = @board.get_rank_and_file(gamepiece.location)
    move = turn_move(gamepiece, index)
    execute_move(gamepiece, move)
  end

  def turn_start
    loop do
      puts "Choose the piece you want to move by typing the location of the piece. ex: a1"
      location = gets.chomp

      gamepiece = @board.find_gamepiece(location)
      
      return gamepiece if gamepiece != "-" || !gamepiece.nil?

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
    if @board.enemy_spot?(gamepiece.color, move)
      puts "This spot is the enemy spot."
    else
      @board.move_gamepiece(gamepiece.location, move, gamepiece)
      gamepiece.change_location(move)
    end
  end


  def assign_players
    2.times do |num|
      puts "What is player #{num + 1}'s name?"
      name = gets.chomp
      create_player(name)
      puts "What color is player #{num + 1}? (black/white)"
      color = gets.chomp
      @players[num].assign_color(color)
    end
  end

  def create_player(name)
    @players << Player.new(name)
  end

end