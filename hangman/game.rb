# hangman

# rules: 
# game runs the welcome to hangman, list rules, how to win. then picks a word and displays from the dictionary.
# check if game is over, if not, then run turn.
# prompt the player to choose a letter
# check if letter is apart of the word. if it is, place it in the appropriate spot
  # if not, then increment the a counter that keeps track of how many turns the player has left.
# run line 6 again
# 

class Game
  # need to load the 5desk.txt in order to get all the words that are available to be chosen for the game
  # randomly choose word to be the word for the game
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

# it works (kind of)! 
# what needs to be added
# a file that will run the game
# if they guess the character correctly and the word has more than one of those characters, the letter needs to be added to those spots
# if they guess a dupe of the letter (add the dupes to the terminal so they don't lol), return that it was a dupe, and play round again, not decrementing the lives, and not adding the letter.
# can we use less methods? 
# add tests (this should be added first, for TDD, but i don't understand TDD right now.)