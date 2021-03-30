# You should write a program that will read in the maze, try to explore a path through it to the end, and then print out a completed path like so. 
# If there is no such path, it should inform the user.
# Make your program run as a command line script, taking in the name of a maze file on the command line.

class Maze
  attr_reader :maze
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
      # if you run into an error, you need to go backwards, and check a different path.
        # how?
  
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

  # Process of pathfinding
    # Start at point A
    # Need to get to point B
      # if point A is [6,1]
      # point B is [1, 15]
        # if you subtract the cols and rows, 
        # you get [-5, 14] which is also in the NE direction.
          # north is -1 in the row, south is +1 in the row.
          # east is +1 in the col, west is -1 in the col
          # you can decide on which direction you want to travel.
          # it should tell you which direction point B is from point A. 
            # make a move that is in the positive direction.

  # Objective: Get to the row of the end point
    # if you can go in the direction of the end point, go.
      # elsif you can go towards the end point (east/west), then go there.
      # else you need to go away from endpoint.
        # if you can go vertically, go
        # else if you can go horizontally, go
  def navigate_maze(start, endpoint)
    counter = 0
    queue = []
    queue << [endpoint[0], endpoint[1], counter]
    while !queue.empty?
      current = queue[0]
      
      # Want to insert the points that we are adding onto the 2d array
        # So that I can easily check if there are dupes.
        # So that I can trace the route at the end separately.
      # Only add to the queue if the location isn't in the queue, or isn't a wall ("*")
      
      if self[current[0] + 1, current[1]] == " "
        
        if self[current[0] + 1, current[1]] == "S"
          break
        end

        @maze[current[0] + 1][current[1]] = current[2] + 1
        queue << [current[0] + 1, current[1], current[2] + 1]
      end

      if self[current[0] - 1, current[1]] == " "

        if self[current[0] + 1, current[1]] == "S"
          break
        end

        @maze[current[0] - 1][current[1]] = current[2] + 1
        queue << [current[0] - 1, current[1], current[2] + 1]      
      end

      if self[current[0], current[1] + 1] == " "

        if self[current[0] + 1, current[1]] == "S"
          break
        end

        @maze[current[0]][current[1] + 1] = current[2] + 1
        queue << [current[0], current[1] + 1, current[2] + 1]

      end

      if self[current[0], current[1] - 1] == " "

        if self[current[0] + 1, current[1]] == "S"
          break
        end

        @maze[current[0]][current[1] - 1] = current[2] + 1
        queue << [current[0], current[1] - 1, current[2] + 1]
      end

      queue.shift
    end
  end

  def route(start, endpoint)
    navigate_maze(start, endpoint)
    path = ["S"]

    current_location = start

    until self[current_location[0], current_location[1]] == "E"
      adjacent_locations = []

      adjacent_locations << [current_location[0] - 1, current_location[1]] unless self[current_location[0] - 1, current_location[1]] == "*"
      adjacent_locations << [current_location[0] + 1, current_location[1]] unless self[current_location[0] + 1, current_location[1]] == "*"
      adjacent_locations << [current_location[0], current_location[1] - 1] unless self[current_location[0], current_location[1] - 1] == "*"
      adjacent_locations << [current_location[0], current_location[1] + 1] unless self[current_location[0], current_location[1] + 1] == "*"

      min = adjacent_locations[0]
      adjacent_locations.each do |location|

        if self[location[0], location[1]] == " "
          next
        end

        if self[location[0], location[1]] == "S"
          next
        end

        if self[location[0], location[1]].to_i < self[min[0], min[1]].to_i
          min = location
        else
          next
        end
      end
      path << min
      current_location = min
    end
    path.pop
    path.push("E")
    return path
  end

  def [](row, col)
    @maze[row][col]
  end
end