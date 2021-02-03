require_relative "node.rb"

class Graph
  attr_reader :nodes
  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node.position] = node
  end

  def add_edge(first_position, second_position)
    @nodes[first_position].add_edge(@nodes[second_position])
  end

  def [](position)
    @nodes[position]
  end

end