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
    until self.level_order.include?(final_location)
      @previous_locations << starting_location
      valid_moves = self.move
      @location = @graph[starting_location].get_next
    end
    configure_ans(@graph[final_location])
  end

  def move(current_location = @location.position, moves = [])
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
      moves << child.position
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

  def level_order(node = @location, queue = [])
    level_order_array = []
    return nil if node.nil?

    queue.push(node)
    
    until queue.empty?
      current = queue[0]
      level_order_array << current.position
      current.children.each do |node|
        queue.push(node)
      end
      queue.shift
    end
    level_order_array
  end

  def configure_ans(node)
    ans = [node.position]

    until node.parent.nil?
      ans.unshift(node.parent)
      node = graph[node.parent]
    end
    ans
  end
end
