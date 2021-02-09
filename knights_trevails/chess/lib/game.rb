require_relative "board.rb"
require_relative "player.rb"

class Game
  def initialize
    @board = Board.new
    @players = []
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