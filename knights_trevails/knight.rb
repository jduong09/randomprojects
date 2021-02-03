require_relative "graph.rb"
require_relative "node.rb"

class Knight
  attr_reader :color, :marker
  attr_accessor :position

  def initialize(location)
    @location = location
    @graph = Graph.new
  end

  def knight_moves(starting_location = @location, final_location)
    @graph.add_node(Node.new(starting_location))
    self.move
    @location = @graph[starting_location].get_next
  end

  def move(current_location = @location)
    knight_directions = [[-2, -1], [-2, 1], [2, 1], [2,-1], [-1, 2], [-1, -2], [1, 2], [1, -2]]
    
    knight_directions.each do |direction|
      row = current_location[0] + direction[0]
      col = current_location[1] + direction[1]
      next if self.invalid_move?([row, col])
      direction = [row, col]
      @graph.add_node(Node.new(direction))
      @graph.add_edge(current_location, direction)
    end
    return @graph[current_location]
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
