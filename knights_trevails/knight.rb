require_relative "graph.rb"
require_relative "node.rb"

class Knight
  attr_reader :graph, :location

  def initialize(location)
    @graph = Graph.new
    @location = graph.add_node(Node.new(location))
    @previous_locations = []
  end

  def knight_moves(starting_location = @location.position, final_location)
      @previous_locations << @location.position
      valid_moves = self.move
      @location = @graph[starting_location].get_next
      
      if valid_moves.include?(final_location)
        @previous_locations << final_location
        return @previous_locations
      end
  end

  def move(current_location = @location.position, queue = [])
    knight_directions = [[-2, -1], [-2, 1], [2, 1], [2,-1], [-1, 2], [-1, -2], [1, 2], [1, -2]]
    
    knight_directions.each do |direction|
      row = current_location[0] + direction[0]
      col = current_location[1] + direction[1]
      next if self.invalid_move?([row, col])
      next if @previous_locations.include?([row, col])
      direction = [row, col]
      child = Node.new(direction)
      @graph.add_node(child)
      @graph.add_edge(current_location, child.position)
      queue << child.position
    end
    queue
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
end
