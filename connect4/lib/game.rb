require_relative "player"

class Game

  attr_reader :board, :players

  def initialize
    @board = Array.new(6) { Array.new(7) {"-"} }
    @players = []
    @turn = 0
  end

  def play_game
    puts "How many players will be playing?"
    num_of_players = gets.to_i
    assign_players(num_of_players)
    display_board
    game_loop
  end

  def assign_players(number_of_players)
    number_of_players.times do
      @players << create_player
    end
    
    @players
  end

  def create_player
    puts "What is the player's name?"
    player_name = gets.chomp
    puts "What is the player's marker?"
    player_marker = gets.chomp
    Player.new(player_name, player_marker)
  end

  def game_loop
    loop do
      turn = take_turn
      display_board
      break if game_over?(turn[0], turn[1])
    end
    puts "Winner!"
  end

  def take_turn
    current_player = @players[@turn % 2]
    opponents_player = @players[(@turn + 1) % 2]
    @turn += 1
    puts "#{current_player.name}, it is your turn. Please type the row and column you want your game piece to be."
    row = gets.to_i
    col = gets.to_i
    coordinates = [row, col]
    change_board(coordinates, current_player.marker, opponents_player.marker) if verify_input(coordinates)
  end

  def change_board(coordinates, player_marker, opponents_marker)
    row = coordinates[0]
    col = coordinates[1]
    new_spot = find_available_spot(row, col, player_marker, opponents_marker)
    new_row = new_spot[0]
    new_col = new_spot[1]
    @board[new_row][new_col] = player_marker
    return [new_row, new_col], player_marker
  end

  def find_available_spot(row, col, player_marker, opponents_marker)
    return [row - 1, col] if @board[row][col] == opponents_marker || @board[row][col] == player_marker
    return [row, col] if row == 5|| row < 0


    find_available_spot(row + 1, col, player_marker, opponents_marker)
  end

  def verify_input(coordinates)
    if coordinates[0] < 0 || coordinates[0] > 5
      puts "Row input is too low or too high"
      return false
    elsif coordinates[1] < 0 || coordinates[1] > 6
      puts "Column input is too low or too high"
      return false
    elsif self.board[coordinates[0]][coordinates[1]] != "-"
      puts "Coordinates taken. Choose again."
      return false
    else
      return true
    end
  end

  def game_over?(coordinates, marker)
    return true if check_vertical?(marker, coordinates[0], coordinates[1])
    return true if check_horizontal_left?(marker, coordinates[0], coordinates[1])
    return true if check_horizontal_right?(marker, coordinates[0], coordinates[1])
    return true if check_diagonally_down_left?(marker, coordinates[0], coordinates[1])
    return true if check_diagonally_down_right?(marker, coordinates[0], coordinates[1])
    return true if check_diagonally_up_right?(marker, coordinates[0], coordinates[1])
    return true if check_diagonally_up_left?(marker, coordinates[0], coordinates[1])
  end

  def check_vertical?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if row > 5 || row < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_vertical?(marker, row + 1, col, matches)
  end

  def check_horizontal_left?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if col > 6 || col < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_horizontal_left?(marker, row, col - 1, matches)
  end

  def check_horizontal_right?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if col > 6 || col < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_horizontal_right?(marker, row, col + 1, matches)
  end

  def check_diagonally_down_left?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if row > 5 || row < 0
    return false if col > 6 || col < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_diagonally_down_left?(marker, row + 1, col - 1, matches)
  end

  def check_diagonally_down_right?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if row > 5 || row < 0
    return false if col > 6 || col < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_diagonally_down_right?(marker, row + 1, col + 1, matches)
  end

  def check_diagonally_up_right?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if row > 5 || row < 0
    return false if col > 6 || col < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_diagonally_up_right?(marker, row - 1, col + 1, matches)
  end

  def check_diagonally_up_left?(marker, row, col, matches = 0)
    return true if matches == 4
    return false if row > 5 || row < 0
    return false if col > 6 || col < 0
    return false if @board[row][col] != marker

    matches += 1 if @board[row][col] == marker
    check_diagonally_up_left?(marker, row - 1, col - 1, matches)
  end

  def display_board
    string = ""
    @board.each do |row|
      row_string = ""
      row.each do |col|
        row_string += col + " "
      end
      row_string += "\n"
      string += row_string
    end
    puts string
  end
end