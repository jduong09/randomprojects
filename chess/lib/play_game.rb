require_relative "game.rb"
require_relative "board.rb"
require_relative "player.rb"

Dir["/game_pieces/*.rb"].each {|file| require file }

game = Game.new
game.game_loop