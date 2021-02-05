class Node
  attr_accessor :position, :children, :parent

  def initialize(position)
    @position = position
    @parent = nil
    @children = []
  end

  def add_edge(child)
    @children << child
  end

  def get_next
    @children[0]
  end

end