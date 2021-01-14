#run rspec tic_tac_toe_spec.rb
#Arrange
#Act
#Assert

require_relative "../lib/board.rb"

describe Board do 
  #describe "#initialize" do
    # no need to test because it is just initializing variables
  #end

  describe "#play_game" do
    # do not need to test this as it is a public script method. 
    # need to test the methods inside.
    #describe "#game_intro" do
      # is a bunch of puts and gets statements.
      # do not need to test the puts
      # test the gets methods, so that it returns valid input?
    #end

    #describe "#display_board" do
      # do not understand how to test a loop. 
    #end

    describe "#game_loop" do 

      subject(:tie_game) { described_class.new() }
      # test if receive 9 times (9 turns)
        # test that subject receives take_turn 9 times.
        it "sends take_turn 9 times" do
          expect(tie_game).to receive(:take_turn).exactly(9).times
          tie_game.game_loop
        end
      # test "#take_turn"
        # test "#player.move"
        # test spot_taken?
      # test "#game_over?"
        # this is the most important test, and the most complex in this testing suite.
        # how are we doing to test all 8 possibilities of winning.
      # test if receive 9 times and not game over, then test if we receive "It's a tie!" message
    end
  end
end
