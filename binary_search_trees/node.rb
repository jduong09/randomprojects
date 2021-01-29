# As a bonus, try including the Comparable module and compare nodes using their data attribute.
class Node
  attr_accessor :left, :right, :data
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end