require_relative "../lib/game.rb"
require_relative "../lib/player.rb"

describe Game do
  describe "#initialize" do
    context "when running Game.new" do
      subject(:new_game) { described_class.new() }

      it "creates a 2D array and stores into the @board instance variable" do
        expect(new_game.board).to eq([["O","O","O","O","O","O","O"],["O","O","O","O","O","O","O"],["O","O","O","O","O","O","O"],["O","O","O","O","O","O","O"],["O","O","O","O","O","O","O"],["O","O","O","O","O","O","O"]])
      end
    end
  end

  describe "#play_game" do
    #describe "#intro" do
      #intro will be puts statements.
      #no need to test
    #end
    describe "#assign_players" do
      subject(:game_assign) { described_class.new() }
      let (:player) { Player.new("Justin") }
      let(:player_2) { Player.new("Julian") }

      it "assigns a new player instance to @players" do
        allow(game_assign).to receive(:create_player).and_return(player)
        game_assign.assign_players(1)
        expect(game_assign.players).to eq([player])
      end

      it "assigns 2 new players to @players" do
        allow(game_assign).to receive(:create_player).and_return(player, player_2)
        game_assign.assign_players(2)
        expect(game_assign.players).to eq([player, player_2])
      end
    end
  end
end