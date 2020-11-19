# hangman

# Now implement the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game. Remember what you learned about serializing objects… you can serialize your game class too!
# When the program first loads, add in an option that allows you to open one of your saved games, which should jump you exactly back to where you were when you saved. Play on!

require "json"

class Game
  def initialize
    @name = ""
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
    puts "Your current string is: "
    puts @string.join(" ")
  end

  def check_match(letter)
    if @attempted_guesses.include?(letter)
      puts "Duplicate letter; choose again"
    elsif @letters.include?(letter)
      puts "You have guessed correctly!"
      self.update_board(letter)
      @attempted_guesses << letter
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

  def save_game
    Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
    
    puts "Enter a save name:"
    @name = gets.chomp
    filename = "saved_games/#{@name}"

    File.open(filename,'w') do |file|
      file.puts self.serialize
    end
  end

  def load_game(name)
    file = File.new("./saved_games/#{name}", 'r')
    serialized_object = file.gets
    self.unserialize(serialized_object)
  end

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    JSON.dump obj
  end

  def unserialize(string)
    obj = JSON.load(string)
    obj.each do |key, values|
      instance_variable_set(key, values)
    end
  end
end