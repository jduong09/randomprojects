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
      let (:player) { Player.new("Justin", "x") }
      let(:player_2) { Player.new("Julian", "o") }

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

    describe "#game_loop" do
      # how the game will run.
      describe "#take_turn" do

        subject(:game_turn) { described_class.new() }
        let (:player_1) { Player.new("Julian", "x") }
        let (:player_2) { Player.new("Justin Tran", "o") }

        before do
          allow(game_turn).to receive(:create_player).and_return(player_1, player_2)
          game_turn.assign_players(2)
        end

        it "on first turn, prompts player 1 to take turn" do
          message_prompt = "Julian, it is your turn. Please type the row and column you want your game piece to be."
          expect(game_turn).to receive(:puts).with(message_prompt)
          game_turn.take_turn
        end

        it "changes the player's turn" do
          game_turn.take_turn
          turn = game_turn.instance_variable_get(:@turn)
          expect(turn).to eql(1)
        end

        describe "#change_board" do
          subject(:board_change) { described_class.new() }

          it "receives input and changes @board" do
            player_marker = "x"
            coordinates = [0,1]
            board_change.change_board(coordinates, player_marker)
            expect(board_change.board[0][1]).to eq("x")  
          end
        end

        describe "#verify_input" do
          subject(:game_invalid_input) { described_class.new }

          it "returns error message if row input is too high" do
            invalid_coordinates = [7, 0]
            error_message = "Row input is too low or too high"
            expect(game_invalid_input).to receive(:puts).with(error_message)
            game_invalid_input.verify_input(invalid_coordinates)
          end

          it "returns error message if row input is too low" do
            invalid_coordinates = [-5, 0]
            error_message = "Row input is too low or too high"
            expect(game_invalid_input).to receive(:puts).with(error_message)
            game_invalid_input.verify_input(invalid_coordinates)
          end

          it "returns error message if column input is too high" do
            invalid_coordinates = [0, 10]
            error_message = "Column input is too low or too high"
            expect(game_invalid_input).to receive(:puts).with(error_message)
            game_invalid_input.verify_input(invalid_coordinates)
          end

          it "returns error message if column input is too low" do
            invalid_coordinates = [0, -10]
            error_message = "Column input is too low or too high"
            expect(game_invalid_input).to receive(:puts).with(error_message)
            game_invalid_input.verify_input(invalid_coordinates)
          end

          before do
            coordinates = [0,0]
            allow(game_invalid_input).to receive(:take_turn).and_return(coordinates)
          end

          it "returns error message if coordinates is taken" do
            dupe_coordinates = [0,0]
            error_message = "Coordinates taken. Choose again."
            expect(game_invalid_input).to receive(:puts).with(error_message)
            game_invalid_input.verify_input(dupe_coordinates)
          end
        end
      end
    end
  end
end