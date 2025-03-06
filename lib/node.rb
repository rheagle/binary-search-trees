class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end


  # Compare based on the node value
  # Allows you to easily use comparison operators (<, >, ==, etc.)
  # to compare nodes based on their values in the binary search tree
  def <=>(other)
    @data <=> other.data
  end
end
