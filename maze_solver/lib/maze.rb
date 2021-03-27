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
  # Recursion: (confused)
    # run navigate_maze recursively until you run into E. 
    # each time you move, you would push into an array(this keeps track of your previous movements.)
    # if you run into a wall, then you would return.
      # this array would be useless.
    # if you run into E, then you would return the array, this is our path that we are looking for.

  # Iteratively:
    # Until you run into "E"
      # go in each direction
      # add that direction to an array
      # if you run into a "*", break
  
  # Alternatively:
    # Loop
      # Go in a direction
        # if you run into a *, need to go a different direction
        # if you run into a " ", change new_location to current location
          # Mark old location as an x
        # if you run into an x, you need to go in a different direction

  # Problem:
    # Loop needs to backtrack to where other moves are available, and make those other moves. 
      # How will we tackle the backtrack to doing other moves when there are no other other available at this spot.
        # Add the moves to an array, if you run into a dead end, change the current_location to the previous one; pop the array. 

  def navigate_maze(current_location)
    movements = []

    row = current_location[0]
    col = current_location[1]

    if current_location == "E"
      return "At the end."
    end

    if go_north(current_location)
      @maze[row][col] = "x"
      current_location = [row - 1, col]
      navigate_maze(current_location)
      movements << current_location
    elsif go_south(current_location)
      @maze[row][col] = "x"
      current_location = [row + 1, col]
      navigate_maze(current_location)
      movements << current_location
    elsif go_east(current_location)
      @maze[row][col] = "x"
      current_location = [row, col + 1]
      navigate_maze(current_location)
      movements << current_location
    elsif go_west(current_location)
      @maze[row][col] = "x"
      current_location = [row, col - 1]
      navigate_maze(current_location)
      movements << current_location
    else 
      
    end

  end

  #takes in current location as coordinates; ex: [0,0]
  def go_north(coordinates)
    row = coordinates[0]
    col = coordinates[1]

    if self[row - 1, col] == " "
      return true
    else
      return false
    end
  end

  def go_south(coordinates)
    row = coordinates[0]
    col = coordinates[1]

    if self[row + 1, col] == " "
      return true
    else
      return false
    end
  end

  def go_east(coordinates)
    row = coordinates[0]
    col = coordinates[1]

    if self[row, col + 1] == " "
      return true
    else
      return false
    end
  end

  def go_west(coordinates)
    row = coordinates[0]
    col = coordinates[1]

    if self[row, col - 1] == " "
      return true
    else
      return false
    end
  end

  def [](row, col)
    @maze[row][col]
  end
end