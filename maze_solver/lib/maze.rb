# You should write a program that will read in the maze, try to explore a path through it to the end, and then print out a completed path like so. 
# If there is no such path, it should inform the user.
# Make your program run as a command line script, taking in the name of a maze file on the command line.

class Maze
  #initialize maze class with textfile
  #create instance variable, which will be our maze.
  def initialize(textfile_name)
    @maze = load(textfile_name)
  end

  #load the text file into an array
  def load(textfile_name)
    array = []
    
    File.foreach("#{textfile_name}") do |line| 

      array_line = []
      line.each_char { |char| array_line << char }
      array << array_line

    end

    return array
  end

  #Starting at S, move only when the space is a space character, and find the E.
  #Using recursion, we just need one method. 
  def navigate_maze(current_location)
    return if current_location == "*"

    row = current_location[0]
    col = current_location[1]

    go_north([])
  end

  def check_spot
    
  end

  #takes in current location as coordinates; ex: [0,0]
  def go_north(coordinates)
    row = coordinates[0]
    col = coordinates[1]
    return [row - 1, col]
  end

  def go_south(coordinates)
    row = coordinates[0]
    col = coordinates[1]
    return [row + 1, col]
  end

  def go_east(coordinates)
    row = coordinates[0]
    col = coordinates[1]
    return [row, col + 1]
  end

  def go_west(coordinates)
    row = coordinates[0]
    col = coordinates[1]
    return [row, col - 1]
  end

  def [](row, col)
    @maze[row][col]
  end
end