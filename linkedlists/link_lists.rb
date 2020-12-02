#linked list project from TheOdinProject
# [ Node(head) ] --> [ Node ] --> [ Node ] --> [ Node ] --> [ Node(tail) ] --> nil

# one major problem I'm seeing is that when i prepend and append, it is adding to the @head instance variable. i should use a @list variable.
require_relative "node"
include Enumerable

class Linklist
  attr_accessor :name
  
  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    if @head.nil?
      @head = value
      @tail = value
    else
      @tail.next = value
      @tail = value
    end
  end

  def prepend(value)
    if @head.nil?
      @head = value
      @tail = value
    else
      value.next = @head
      @head = value
    end
  end

  def size
    return 0 if @head.nil?
    counter = 0
    self.each { |node| counter += 1 }
    return counter
  end

  def head
    return nil if @head.nil?
    self.each do |node|
      return node.data
    end
  end

  def tail
    return @tail
  end

  def at(index)

  end

  def pop

  end

  def contains?(value)

  end

  def find(value)

  end

  # ( value ) -> ( value ) -> ( value ) -> nil
  def to_s

  end

  def each
    return nil if @head.nil?
    node = @head
    until node.nil?
      yield node
      node = node.next
    end
  end

  # extra credit
  def insert_at(value, index)

  end

  def remove_at(index)

  end
end
