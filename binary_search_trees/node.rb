include Comparable

# As a bonus, try including the Comparable module and compare nodes using their data attribute.
class Node
  attr_accessor :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other
  end
end