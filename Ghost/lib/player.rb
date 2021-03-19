class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def guess
    gets.chomp
  end

  def alert_invalid_guess
    puts "Invalid guess. Choose a letter that will continue to fragment chain."
  end
end