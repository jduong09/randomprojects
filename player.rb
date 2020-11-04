class Player
  attr_reader :name, :marker
  def initialize(name, marker)
    @name = name
    @marker = marker
  end

  def move
    row = ""
    col = ""
    valid_turn = false
    puts "It is your time, #{self.name}."
    puts "Input the places you want to place your marker on:"
    until valid_turn == true
      puts "Please put the row you want to place your marker on:"
      row = gets.chomp.to_i
      puts "Please put the column you want to place your marker on:"
      col = gets.chomp.to_i
      if valid_move?(row) && valid_move?(col)
        valid_turn = true
      end
    end
    coordinates = row, col
    return coordinates
  end

  def valid_move?(move)
    if move < 0 || move > 2
      puts "Invalid move: Please choose 0, 1, or 2"
      false
    end
    true
  end
end