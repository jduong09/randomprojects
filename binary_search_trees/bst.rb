require_relative "node"

class Tree
  attr_accessor :array, :root
  def initialize(arr)
    @array = arr.sort.uniq
    @root = build_tree(array)
  end

  # the build_tree method should return the level-1 root node.
  # time complexity is O(n)
  def build_tree(arr)
    return nil if arr.empty?

    mid = (arr.length - 1) / 2

    root = Node.new(arr[mid])
    
    root.left = build_tree(arr[0...mid])

    root.right = build_tree(arr[(mid + 1)..-1])

    return root
  end

  def sortUnorderedArray
    isSorted = false
    until isSorted
      isSorted = true
      (@array.length - 1).times do |idx|
        if @array[idx] > @array[idx + 1]
          @array[idx], @array[idx + 1] = @array[idx + 1], @array[idx]
          isSorted = false
        else
          next
        end
      end
    end
  end

  def removeDuplicates
    @array.each_index do |idx|
      if @array[idx] == @array[idx + 1]
        @array.slice!(idx)
      end
    end
  end

  def insert(value, node = @root)
    return nil if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = @root)
    return nil if node.nil?

    node
  end

  #def find_min(node)
    #current_node = node
    #while current_node.left == true
      #current_node = current_node.left
    #end
    #return current_node
  #end

  def find(value, node = @root)
    return node if node.data == value || node == nil

    if value < node.data
      return find(value, node.left)
    end

    if value > node.data
      return find(value, node.right)
    end
  end

  # traverse the tree in breadth-first level order.
  # traverse the tree left to right, before going one level up. root is level 1, next level is level 2.
    # if no node exists, return.   
    # check to see if the current node has left and right children. 
      # If current node has children, place into queue. after checking current node, move to next node in queue.
      # if current node has only a left child, place into queue.
      # if current node has only a right child, place into queue.
    # if current node has no children, we want to return out of the recursion call. 
  def level_order(node = @root, queue = [])
    return nil if node.nil?
    
    queue.push(node)

    until queue.empty?
      current = queue[0]
      puts "#{current.data}"
      queue.push(current.left) if !current.left.nil?
      queue.push(current.right) if !current.right.nil?
      queue.shift 
    end
  end

  # Follows the (LDR) pattern
  def inorder(node = @root)
    return nil if node.nil?

    inorder(node.left) unless node.left.nil?
    puts "#{node.data}"
    inorder(node.right) unless node.right.nil?
  end

  # Follows the (DLR) pattern
  def preorder(node = @root)
    return nil if node.nil?

    puts "#{node.data}"
    preorder(node.left) unless node.left.nil?
    preorder(node.right) unless node.right.nil?
  end

  # Follows the (LRD) pattern
  def postorder(node = @root)
    return nil if node.nil?

    postorder(node.left) unless node.left.nil?
    postorder(node.right) unless node.right.nil?
    puts "#{node.data}"
  end

  # Height is defined as the number of edges in longest path from a given node to a leaf node.
  def height(node = @root, idx = 0)
    return nil if node.nil?
    return idx if node.left.nil? && node.right.nil?

    left_height = height(node.left, idx + 1)
    right_height = height(node.right, idx + 1)
  end
  
  # Depth is defined as the number of edges in path from a given node to the tree’s root node.
  def depth(node)
    root_height = height(@root)
    node_height = height(node)
    
    return root_height - node_height
  end

  # A balanced tree is one where the difference between heights of left subtree and right subtree of every node is not more than 1.
  def balanced?(node = @root)
    return true if node.nil?
  end

  # Tip: You’ll want to create a level-order array of the tree before passing the array back into the #build_tree method.
  def rebalance

  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# write a simple driver script

newBST = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

puts newBST.balanced?

# build tree should return 
# the input needs to be sorted and duplicates need to be removed before inserting into the build tree method.