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
    puts "It is your time, #{self.name}."
    puts "Input the row & column you want to place your marker on:"
    puts "Firstly, the row:"
    row = gets.chomp.to_i
    until valid_move?(row)
      puts "Please put the row you want to place your marker on:"
      row = gets.chomp.to_i
    end

    puts "Now, the column:"
    col = gets.chomp.to_i
    until valid_move?(col)
      puts "Please put the column you want to place your marker on:"
      col = gets.chomp.to_i
    end

    coordinates = row, col
    return coordinates
  end

  def valid_move?(move)
    if move < 0 || move > 2
      puts "Invalid move: #{move} is too low or high."
      return false
    end
    true
  end
end