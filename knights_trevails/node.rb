class Node
  attr_accessor :position, :children, :parent

  def initialize(position)
    @position = position
    @parent = nil
    @children = []
  end

  def add_child(child)
    @children << child
  end

end