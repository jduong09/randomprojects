require_relative "player.rb"
require "json"

class Game

  #Ghost (also known as Ghosts in Hoyle's Rules of Games) is a written or spoken word game
  #In which players take turns adding letters to a growing word fragment, trying not to be the one to complete a valid word. Each fragment must be the beginning of an actual word, and usually some minimum is set on the length of a word that counts, such as three or four letters.
  #The player who completes a word loses the round and earns a "letter" (as in the basketball game horse), with players being eliminated when they have been given all five letters of the word "ghost".
  
  def initialize
    @dictionary = File.readlines("lib/dictionary.txt").map(&:chomp)
    @fragment = ""
    @players = []
  end

  def game_intro
    puts "Welcome to Ghost, the written or spoken word game."
    puts "Each player will take turns adding letters to a word fragment, trying NOT to be the one to complete a valid word."
    puts "Lets start by creating players. Player 1, what is your name?"
    player_1 = gets.chomp
    create_player(player_1)
    puts "Player 2, what about you, what is your name?"
    player_2 = gets.chomp
    create_player(player_2)
    puts "Awesome, now that we have the two players, let's start! #{@players[0].name}, you will go first!"
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
    end

    if choice == "2"
      game_over?(@fragment)
    end
  end

  def current_player
    @players.first
  end

  def previous_player
    @players.rotate
  end

  def next_player!

  end

  # Valid_play checks if the fragment can still make a word in the dictionary set.
  def valid_play?(letter)
    string = @fragment + letter

    @dictionary.each do |word|
      if word.match?(string)
        return true
      end
    end
    player.alert_invalid_guess
    return false
  end

  def game_over?(fragment)
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