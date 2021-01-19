class Game

  attr_reader :board, :players

  def initialize
    @board = Array.new(6) { Array.new(7) {"O"} }
    @players = []
  end

  def play_game
    puts "How many players will be playing?"
    num_of_players = gets.to_i
    assign_players(num_of_players)
  end

  def assign_players(number_of_players)
    number_of_players.times do
      @players << create_player
    end
    
    @players
  end

  def create_player
    player_name = gets.chomp
    Player.new(player_name)
  end
end