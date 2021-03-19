require_relative "player.rb"
require "json"

class Game
  MAX_NUM_OF_LOSSES = 5
  #Ghost (also known as Ghosts in Hoyle's Rules of Games) is a written or spoken word game
  #In which players take turns adding letters to a growing word fragment, trying not to be the one to complete a valid word. Each fragment must be the beginning of an actual word, and usually some minimum is set on the length of a word that counts, such as three or four letters.
  #The player who completes a word loses the round and earns a "letter" (as in the basketball game horse), with players being eliminated when they have been given all five letters of the word "ghost".
  
  def initialize
    @dictionary = File.readlines("lib/dictionary.txt").map(&:chomp)
    @fragment = ""
    @players = []
    @losses = Hash.new { |losses, player| losses[player] = 0 }
  end

  def run 
    game_intro
    play_round until game_over?

    puts "#{winner} is the winner!"
  end

  def game_intro
    puts "Welcome to Ghost, the written or spoken word game."
    puts "Each player will take turns adding letters to a word fragment, trying NOT to be the one to complete a valid word."
    puts "Lets start by creating players. How many players will be playing?"
    num_of_players = gets.chomp.to_i

    num_of_players.times do |player_num|
      puts "Player #{player_num + 1}, what is your name?"
      player = gets.chomp
      create_player(player)
    end

    puts "Awesome, now that we have the #{num_of_players} players, let's start! #{@players[0].name}, you will go first!"
  end

  def play_round
    @fragment = ""

    until round_over?
      take_turn(current_player)
      next_player!
    end

    update_standings
  end

  def take_turn(player)
    puts "#{player.name}, it's your turn."
    puts "The fragment is '#{@fragment}'"
    puts "Choose a letter to add to the fragment."
    loop do
      letter = player.guess

      if valid_play?(letter) == false
        player.alert_invalid_guess
      end
    
      if valid_play?(letter)
        @fragment += letter
        break
      end

    end

  end

  def current_player
    #current player will be the first person in the array
    @players.first
  end

  def previous_player #player that took the turn beforehand.
    #Check from the back, because when you do next player and rotate, the next player will be at the end of the array.
    (@players.length - 1).downto(0).each do |idx|
      player = @players[idx]

      return player if @losses[player.name] < MAX_NUM_OF_LOSSES
    end
  end

  def next_player! 
    @players.rotate!
    #next_player! should rotate the array in order to move the next player to the first, and then current_player will take the first player.
    #However, it needs to check that the front has someone with lives.
    @players.rotate! until @losses[current_player.name] < MAX_NUM_OF_LOSSES
  end

  def round_over?
    is_a_word?(@fragment)
  end

  def game_over?
    # winner is decided when only one person has less than < 5 losses.
    players = @losses.select {|k, v| v < MAX_NUM_OF_LOSSES }

    return true if players.length == 1
    
  end

  def winner #returns the winner. This would be the player with less than max num of losses.
    @losses.each do |k, v|
      return k if v < MAX_NUM_OF_LOSSES
    end
  end

  # Valid_play checks if the fragment can still make a word in the dictionary set.
  def valid_play?(letter)
    string = @fragment + letter

    @dictionary.each do |word|
      if word.match?(string)
        return true
      end
    end
    return false
  end

  def is_a_word?(fragment)
    @dictionary.include?(fragment)
  end

  def create_player(player_name)
    @players << Player.new(player_name)
  end

  def update_standings
    puts "#{previous_player.name} completed the word #{@fragment}."
    @losses[previous_player.name] += 1
    display_standings

    sleep(1)
  end

  def display_standings
    @losses.each do |player, losses|
      puts "#{player} has #{losses} letter."
    end
  end

end
