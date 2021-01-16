#run rspec tic_tac_toe_spec.rb
#Arrange
#Act
#Assert
# To use a message expectation, move 'Assert' before 'Act'.
# And the golden rule is If its hard to test (specially unit test), maybe your are doing something wrong.

require_relative "../lib/board.rb"
require_relative "../lib/player.rb"

describe Board do 

  describe "#initialize" do
    subject(:normal_game) { described_class.new }
    context "it creates a 3 x 3 array" do
      it "creates a board with length 3" do 
        expect(normal_game.board.length).to eql(3)
      end
    end
  end

  describe "#play_game" do
    describe "#game_intro" do
      subject(:normal_game) { described_class.new }

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

        describe "#create_player" do
        let(:player) { "Justin" }
        let(:marker) { "x" }

          it "creates and adds player to @players" do
            normal_game.create_player(player, marker)
            expect(normal_game.players.length).to eql(1)
          end
        end
      end
    end

    describe "#game_loop" do
      context "when taking one turn" do
        describe "#turn_order" do
          subject(:new_game) { described_class.new() }

          it "returns player 1 if the turn is even" do
            expect(new_game.turn_order(2)).to eq(0)
          end

          it "return player 2 if the turn is odd" do
            expect(new_game.turn_order(3)).to eq(1)
          end
        end
      end
    end
  end
end
