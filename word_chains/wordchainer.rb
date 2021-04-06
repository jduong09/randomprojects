require 'set'

class WordChainer
  attr_reader :dictionary
  def initialize(dictionary_file_name)
    @dictionary = File.readlines("#{dictionary_file_name}").map(&:chomp)
    @dictionary = Set.new(@dictionary)
  end

  # Return all words in the dictionary one letter different than the current word.
  # Both words have the same length and only differ at one position
  # ex: 'mat' and 'cat'
  # alphabet consists of 26 letters
  def adjacent_words(word)
    alphabet = ("a".."z").to_a
    adjacent_words = []

    arrayOfWords = word.split("")

    word.each_char_with_index do |old_letter, idx|
      charIndex = alphabet.index(char)

      (1..26).each do |num|
        newCharIndex = charIndex + num

        if newCharIndex > 26
          newCharIndex = newCharIndex % 26
        end
        arrayOfWords[idx] = alphabet[newCharIndex]
        new_word = arrayOfWords.join("")

        next if new_word == word
        
        if @dictionary.include?(new_word)
          adjacent_words << new_word
        end
      end
      arrayOfWords[idx] = char
    end
    adjacent_words
  end

  def run(source)
    current_words = [source]
    all_seen_words = { source => nil }

    while !current_words.empty?
      new_current_words = []
      current_words.each do |word|
        adjacent_words = adjacent_words(word)
        
        adjacent_words.each do |adjacent_word|
          next if all_seen_words.include?(adjacent_word)
          new_current_words << adjacent_word
          all_seen_words[adjacent_word] = word
        end

        new_current_words.each do |new_word|
          puts "#{new_word} came from #{all_seen_words[new_word]}."
        end

      end
      current_words = new_current_words
    end
    all_seen_words
  end

  #def explore_current_words(current_words)
    #current_words.each do |word|
      #adjacent_words = adjacent_words(word)
      
      #adjacent_words.each do |adjacent_word|
        #next if all_seen_words.include?(adjacent_word)
        #new_current_words << adjacent_word
        #all_seen_words << adjacent_word
      #end

    #end
  #end
end

