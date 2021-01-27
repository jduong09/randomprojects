require_relative "node"

class Tree
  attr_reader :array
  def initialize(arr)
    @array = arr
  end

  def root
    self.build_tree
  end

  # the build_tree method should return the level-1 root node.
  # time complexity is O(n)
  def build_tree(arr, start, last)
    return if start > last

    mid = (start + last) / 2

    root = Node.new(arr[mid])
    
    root.left = self.build_tree(arr, start, mid-1)

    root.right = self.build_tree(arr, mid+1, last)

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
    return "Sort Completed!"
  end

  def removeDuplicates
    @array.each_index do |idx|
      if @array[idx] == @array[idx + 1]
        @array.slice!(idx)
      end
    end
    
  end

  def insert(value)
  
  end

  def delete(value)

  end

  def find(value)

  end

  # traverse the tree in breadth-first level order.
  def level_order

  end

  def inorder

  end

  def preorder

  end

  def postorder

  end

  def height(node)

  end

  def depth(node)
  
  end

  def balanced?

  end

  def rebalance

  end
end

# write a simple driver script


easyBST = Tree.new([1,2,3])
easyBST.build_tree([1,2,3], 1, 3)

newBST = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
newBST.sortUnorderedArray()
newBST.removeDuplicates
newBST.build_tree(@array)

  # build tree should return 
  # the input needs to be sorted and duplicates need to be removed before inserting into the build tree method.