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
    self.each do |node|
      if node.next == nil
        return node
      end
    end
  end

  def at(index)
    return nil if @head.nil?
    counter = 0
    self.each do |node|
      counter += 1
      if counter == index
        return node
      end
    end
    return nil
  end

  def pop
    #need the second to last element. Make the second to last item's to be the tail. then we need to remove the last item from the @head.how do we remove instances?
    return nil if @head.nil?
    size = self.size
    second_to_last = size - 1
    index = 0
    node = @tail
    self.each do |node|
      index += 1
      if index == second_to_last
        node.next = nil
        @tail = node
      end
    end
    return node
  end

  def contains?(value)
    return nil if @head.nil?
    self.each { |node| return true if node.data == value }
    return false
  end

  def find(value)
    return nil if @head.nil?
    index = 0
    self.each do |node| 
      index += 1
      if value.data == value
        return index
      end
    end
    return nil
  end

  # ( value ) -> ( value ) -> ( value ) -> nil
  def to_s
    string = ""
    self.each do |node|
      string += "( #{node.data} ) -> "
    end
    return string += "nil"
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