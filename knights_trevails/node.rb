class Node
  attr_accessor :position, :successors

  def initialize(position)
    @position = position
    @successors = []
  end

  def add_edge(successor)
    @successors << successor
  end

  def get_next
    @successors[0].position
  end

  def to_s
    "#{@position} -> #{@successors.map(&:position).join(" ")}"
  end

end