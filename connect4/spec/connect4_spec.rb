require_relative "../lib/game.rb"
require_relative "../lib/player.rb"

describe Game do
  describe "#initialize" do
    context "when running Game.new" do
      subject(:new_game) { described_class.new() }

      it "creates a 2D array and stores into the @board instance variable" do
        expect(new_game.board).to eq([["-","-","-","-","-","-","-"],["-","-","-","-","-","-","-"],["-","-","-","-","-","-","-"],["-","-","-","-","-","-","-"],["-","-","-","-","-","-","-"],["-","-","-","-","-","-","-"]])
      end
    end
  end

  describe "#play_game" do
    
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

        it "on second turn, prompts player 2 to take turn" do
          game_turn.take_turn
          message_prompt = "Justin Tran, it is your turn. Please type the row and column you want your game piece to be."
          expect(game_turn).to receive(:puts).with(message_prompt)
          #expect(turn).to eql(1)
          game_turn.take_turn
        end

        describe "#change_board" do
          subject(:board_change) { described_class.new() }

          it "moves game piece down to the bottom if no spots are taken" do
            player_marker = "x"
            opponents_marker = "o"
            coordinates = [0,0]
            board_change.change_board(coordinates, player_marker, opponents_marker)
            expect(board_change.board[5][0]).to eq("x")
          end

          it "moves game piece down, and stops before opponent's game piece" do
            #set up: place opponents marker at the bottom
            player_marker = "x"
            opponents_marker = "o"
            opponents_coordinates = [0, 0]
            board_change.change_board(opponents_coordinates, opponents_marker, player_marker)

            coordinates = [0,0]
            board_change.change_board(coordinates, player_marker, opponents_marker)
            expect(board_change.board[4][0]).to eq("x")
            expect(board_change.board[5][0]).to eq("o")
          end

          it "keeps previous player's move" do
            player_marker = "x"
            opponents_marker = "o"
            opponents_coordinates = [0, 0]
            board_change.change_board(opponents_coordinates, opponents_marker, player_marker)

            coordinates = [0,0]
            board_change.change_board(coordinates, player_marker, opponents_marker)
            expect(board_change.board[5][0]).to eq("o")
          end
        end

        describe "#verify_input" do
          subject(:game_invalid_input) { described_class.new() }

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
          
          it "returns error message if coordinates is taken" do
            game_invalid_input.change_board([0,0], "x", "o")
            error_message = "Coordinates taken. Choose again."
            expect(game_invalid_input).to receive(:puts).with(error_message)
            game_invalid_input.verify_input([5,0])
          end
        end
      end

      describe "#game_over?" do
        subject(:game_win) { described_class.new() }
        
        it "returns true if player has 4 markers going vertically down" do
          game_win.change_board([0,0], "x", "o")
          game_win.change_board([0,0], "x", "o")
          game_win.change_board([0,0], "x", "o")
          game_win.change_board([0,0], "x", "o")
          expect(game_win.game_over?([2,0], "x")).to be true
        end

        it "returns true if player has 4 markers going horizontally left" do
          game_win.change_board([0,0], "x", "o")
          game_win.change_board([0,1], "x", "o")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,3], "x", "o")
          expect(game_win.game_over?([5,3], "x")).to be true
        end

        it "returns true if player has 4 markers going horizontally right" do
          game_win.change_board([0,3], "x", "o")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,1], "x", "o")
          game_win.change_board([0,0], "x", "o")
          expect(game_win.game_over?([5,0], "x")).to be true
        end

        it "returns true if player has 4 markers going down diagonally left" do
          game_win.change_board([0,0], "x", "o")
          game_win.change_board([0,1], "x", "o")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,1], "x", "o")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,3], "x", "o")
          expect(game_win.game_over?([2,3], "x")).to be true
        end

        it "returns true if player has 4 markers going down diagonally right" do
          game_win.change_board([0,4], "x", "o")
          game_win.change_board([0,5], "x", "o")
          game_win.change_board([0,6], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,5], "x", "o")
          game_win.change_board([0,4], "x", "o")
          game_win.change_board([0,4], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,3], "x", "o")
          expect(game_win.game_over?([2,3], "x")).to be true
        end

        it "returns true if player has 4 markers going up diagonally right" do
          game_win.change_board([0,3], "x", "o")
          game_win.change_board([0,1], "o", "x")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,1], "x", "o")
          game_win.change_board([0,2], "o", "x")
          game_win.change_board([0,2], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,3], "x", "o")
          game_win.change_board([0,0], "x", "o")
          expect(game_win.game_over?([5,0], "x")).to be true
        end

        it "returns true if player has 4 markers going up diagonally right" do
          game_win.change_board([0,3], "x", "o")
          game_win.change_board([0,5], "o", "x")
          game_win.change_board([0,5], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,4], "x", "o")
          game_win.change_board([0,4], "o", "x")
          game_win.change_board([0,4], "x", "o")
          game_win.change_board([0,3], "o", "x")
          game_win.change_board([0,3], "x", "o")
          game_win.change_board([0,6], "x", "o")
          expect(game_win.game_over?([5,6], "x")).to be true
        end
      end
    end
  end
end