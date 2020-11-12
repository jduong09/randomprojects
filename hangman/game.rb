# hangman
# run ruby play_hangman.rb in your terminal.
# MUST HAVE RUBY.

class Game
  def initialize
    words = File.readlines("5desk.txt").map(&:chomp)
    @word = words.sample.downcase
    @remaining_lives = 6
    @string = Array.new(@word.length, "-")
    @letters = @word.split("")
    @attempted_guesses = []
  end

  def start
    puts "Welcome to Hangman, developed by Justin Duong."
    puts "Your word has #{@word.length} letters."
    puts @string.join(" ")
  end

  def take_turn
    puts "You have #{@remaining_lives} lives."
    puts "Player, please choose a letter."
    puts @attempted_guesses.join(" ")
    letter = gets.chomp
    self.check_match(letter)
  end

  def check_match(letter)
    if @letters.include?(letter)
      puts "You have guessed correctly!"
      self.update_board(letter)
      @attempted_guesses << letter
    elsif @attempted_guesses.include?(letter)
      puts "Duplicate letter; choose again"
    else
      puts "You have guessed incorrectly!"
      @remaining_lives -= 1
      @attempted_guesses << letter
      puts "Your remaining lives is #{@remaining_lives}"
    end
  end

  def all_indices(letter)
    indices = []
    @letters.each_with_index do |char, idx|
      if char == letter
        indices << idx
      end
    end
    indices
  end  

  def update_board(letter)
    indices = all_indices(letter)
    indices.each do |idx|
      @string[idx] = letter
    end
    puts "Your current string is: "
    puts @string.join(" ")
  end

  def win?
    if @string.join("") == @word
      puts "You win!"
      return true
    end
    false
  end

  def lose?
    if @remaining_lives == 0
      puts "You ran out of lives! The word was #{@word}"
      return true
    end
    false
  end

  def game_over?
    if win? == true || lose? == true
      return true
    end
    false
  end
end
