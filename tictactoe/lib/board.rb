require_relative './cell.rb'
require_relative './player.rb'

class Player
  attr_reader :name, :marker
  def initialize(name, marker)
    @name = name
    @marker = marker
  end

  def move
    row = ""
    col = ""
    puts "It is your turn, #{self.name}."
    loop do
      puts "Input the row & column you want to place your marker on:"
      row = gets.to_i
      col = gets.to_i
      break if verify_move?(row, col)
    end
    return [row, col]
  end

  def verify_move?(row, col)
    if (row < 0 || row > 2)
      puts "Invalid move: #{row} is too low or high."
      return false
    elsif (col < 0 || col > 2)
      puts "Invalid move: #{col} is too low or high."
      return false
    else
      true
    end
  end
end
