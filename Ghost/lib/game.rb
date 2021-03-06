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
    loop do
      take_turn(current_player)
      next_player!
    end
  end

  def take_turn(player)
    puts "#{player.name}, it's your turn."
    puts "The fragment is '#{@fragment}'"
    puts "Type (1) to choose a letter to add to the fragment. Type (2) to challenge the current fragment as a word."
    choice = gets.chomp

    if choice == "1"
      letter = player.guess
      @fragment += letter if valid_play?(letter)

      if valid_play?(letter) == false
        puts "Not a valid letter, you lose."
        @losses[player] += 1
        round_over
      end
    end

    if choice == "2"
      #if challenger is right, previous player loses round.
      if is_a_word?(@fragment)
        #previous_player loses
        prev_player = previous_player
        @losses[prev_player] += 1
        round_over
      else
        #if challenger is wrong, challenger loses round.
        @losses[player] += 1
        round_over
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

      return player if @losses[player] < MAX_NUM_OF_LOSSES
    end
  end

  def next_player! 
    @players.rotate!
    #next_player! should rotate the array in order to move the next player to the first, and then current_player will take the first player.
    #However, it needs to check that the front has someone with lives.
    @players.rotate! until @losses[current_player] < MAX_NUM_OF_LOSSES
  end

  def round_over
    puts "Round over."
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
    if @dictionary.include?(fragment)
      return true
    else
      return false
    end
  end

  def create_player(player_name)
    @players << Player.new(player_name)
  end

end