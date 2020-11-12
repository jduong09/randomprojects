# Run this file, play_hangman.rb to start a new game!

require_relative "game"

hangman = Game.new

hangman.start
until hangman.game_over?
  hangman.take_turn
  puts "\n"
end
