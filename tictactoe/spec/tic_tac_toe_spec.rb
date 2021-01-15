#run rspec tic_tac_toe_spec.rb
#Arrange
#Act
#Assert
# To use a message expectation, move 'Assert' before 'Act'.

require_relative "../lib/board.rb"
require_relative "../lib/player.rb"

describe Board do 
  describe "#play_game" do
    describe "#game_intro" do
      subject(:normal_game) { described_class.new }
      
      describe "#create_player" do
        let(:player) { "Justin" }
        let(:marker) { "x" }

        it "creates and adds player to @players" do
          normal_game.create_player(player, marker)
          expect(normal_game.players.length).to eql(1)
        end
      end

      context "when starting the game" do
        before do
          player_1 = "Justin"
          player_2 = "Sang"
          marker_1 = "x"
          marker_2 = "o"
          allow(normal_game).to receive(:player_input).and_return(player_1, marker_1, player_2, marker_2)
       end

        it "adds 2 players to @players" do 
          normal_game.game_intro
          expect(normal_game.players.length).to eql(2)
        end
       end
    end
  end
end
