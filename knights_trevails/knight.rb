require_relative "graph.rb"
require_relative "node.rb"

class Knight
  attr_reader :graph, :location

  def initialize(location)
    @graph = Graph.new
    @location = location
    @previous_locations = []
  end

  # knight moves takes in the starting location of the knight piece, and the final piece we want. 
  # it is supposed to return an array containing the least amount of turns to get from starting to final location.
  def knight_moves(starting_location, final_location, queue = [])
    @previous_locations << starting_location
    start_node = Node.new(starting_location)
    @graph.add_node(start_node)
    queue << starting_location

    until queue.empty?
      current = queue[0]
      break if current == final_location
      children = self.move(current)
      children.each do |next_move|
        queue << next_move unless queue.include?(next_move)
      end
      queue.shift
    end
    configure_ans(final_location)
  end

  def move(current_location, moves = [])
    knight_directions = [[-2, -1], [-2, 1], [2, 1], [2,-1], [-1, 2], [-1, -2], [1, 2], [1, -2]]
    
    knight_directions.each do |direction|
      row = current_location[0] + direction[0]
      col = current_location[1] + direction[1]
      next if self.invalid_move?([row, col])
      next if @previous_locations.include?([row, col])
      next if !@graph[[row, col]].nil?
      direction = [row, col]
      child = Node.new(direction)
      @graph.add_node(child)
      @graph.add_edge(current_location, direction)
      moves << direction
    end
    moves
  end

  def invalid_move?(move)
    if move[0] < 0 || move[0] > 7
      return true
    elsif move[1] < 0 || move[1] > 7
      return true
    else
      return false
    end
  end

  def configure_ans(position, ans = [])
    node = @graph[position]
    
    until node.nil?
      ans.unshift(node.position)
      node = @graph[node.parent]
    end
    ans
  end
end