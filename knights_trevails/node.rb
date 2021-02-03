class Node
  attr_accessor :position, :children

  def initialize(position)
    @position = position
    @children = []
  end

  def add_edge(child)
    @children << child
  end

  def get_next
    @children[0]
  end

  def to_s
    "#{@position} -> #{@children.map(&:position).join(" ")}"
  end

end