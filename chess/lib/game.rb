include "board"

class Game
  def initialize
    @board = Board.new
    @players = []
  end

  def assign_players(num_of_players)
    num_of_players.times do |player|
      puts "What is player #{player + 1}'s name"
      name = gets.chomp
      create_player(name)
    end
  end

  def create_player(name)
    @players << Player.new(name)
  end
end