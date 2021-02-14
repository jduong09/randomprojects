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

  def take_turn(color)

    gamepiece = @board.find_gamepiece(color)
    index = @board.get_rank_and_file(gamepiece.location)
    puts "Where do you want your #{gamepiece.icon} to go?"
    valid_moves = @board.gamepiece_moves(gamepiece, index)
    new_location = gets.chomp

    if valid_moves.include?(new_location)
      @board.move_gamepiece(gamepiece.location, new_location, gamepiece.icon)
      gamepiece.change_location(new_location) 
    end

    loop do
      puts "Where do you want your #{gamepiece.icon} to go?"
      new_location = gets.chomp
      make_move() if verify_input?(gamepiece, index)
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

  def verify_input?(gamepiece, move)
    valid_moves = @board.gamepiece_moves(gamepiece, move)
    
  end

end