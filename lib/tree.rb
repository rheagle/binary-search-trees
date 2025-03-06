class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end


  def build_tree(array)
    return nil if array.empty?

    array = array.uniq.sort
    middle_index = array.length / 2
    node = Node.new(array[middle_index])

    node.left = build_tree(array[0...middle_index])
    node.right = build_tree(array[middle_index + 1..-1])

    return node
  end


  def insert(value, current = @root) 
    return @root = Node.new(value) if @root.nil?
    
    if value < current.data
      if current.left.nil?
        current.left = Node.new(value)
      else
        insert(value, current.left)
      end
    else
      if current.right.nil?
        current.right = Node.new(value)
      else
        insert(value, current.right)
      end
    end
  end


  def delete(value, current = @root)
    return nil if current.nil?

    if value == current.data
      #handle three cases
      if current.left.nil? && current.right.nil?
        return nil
      elsif current.right.nil?
        return current.left
      elsif current.left.nil?
        return current.right
      else
        successor = current.right
        while successor.left
          successor = successor.left
        end

        current.data = successor.data
        current.right = delete(successor.data, current.right)
      end

    elsif value < current.data
      current.left = delete(value, current.left)
    else 
      current.right = delete(value, current.right)
    end

    current
  end


  def find(value, current = @root)
    return nil if current.nil?

    if value == current.data
      return current
    elsif value < current.data
      return find(value, current.left)
    else 
      return find(value, current.right)
    end 
  end


  def level_order
    queue = [@root]
    result = []

    while !queue.empty?
      current = queue.shift # take 1st node out of queue

      if block_given?
        yield current
      else
        result.push(current.data)
      end

      if current.left
        queue.push(current.left)
      end
      if current.right
        queue.push(current.right)
      end
    end

    return result if !block_given?
  end


  def inorder
    stack = []
    current = @root
    result = []

    while current || !stack.empty?
      while current
        stack.push(current)
        current = current.left
      end

      current = stack.pop
      if block_given?
        yield current
      else
        result.push(current.data)
      end

      current = current.right
    end

    result
  end


  def preorder(result = [], current = @root)
    return result if current.nil?
    if block_given?
      yield current
    else
      result.push(current.data)
    end

    if block_given?
      preorder(result, current.left) { |node| yield node }
      preorder(result, current.right) { |node| yield node }
    else
      preorder(result, current.left)
      preorder(result, current.right)
    end

    result
  end


  def postorder(result = [], current = @root)
    return result if current.nil?
    #puts "Visiting node: #{current.data}" # Debugging line
  
    if block_given?
      postorder(result, current.left) { |node| yield node }
      postorder(result, current.right) { |node| yield node }
      yield current
      #puts "Node yielded: #{current.data}"  # Debugging line after yielding
    else
      postorder(result, current.left)
      postorder(result, current.right)
      result.push(current.data)
    end
  
    result
  end


  def height(node)
    return -1 if node.nil?
  
    left_height = height(node.left)
    right_height = height(node.right)
  
    if left_height > right_height
      return left_height + 1
    else
      return right_height + 1
    end
  end


  def depth(node, current = @root, edges = 0)
    return nil if current.nil?

    if node.data == current.data
      return edges
    elsif node.data < current.data
      edges += 1
      depth(node, current.left, edges)
    else 
      edges += 1
      depth(node, current.right, edges)
    end 
  end
  
  
  def balanced?
    return true if @root.nil?

    left_height = height(@root.left)
    right_height = height(@root.right)

    if (left_height - right_height).abs > 1 || left_height == -1 || right_height == -1
      return false
    end

    true
  end


  def rebalance
    array = inorder
    @root = build_tree(array)


  end



  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
 
end
