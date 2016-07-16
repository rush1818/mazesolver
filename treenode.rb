require 'byebug'
class PolyTreeNode
  attr_reader :value, :parent
  attr_accessor :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end



  def parent=(parent_node=nil)
    return @parent = nil if parent_node.nil?

    if !@parent.nil?
      self.parent.children.delete(self)
      @parent = nil
    end

    @parent = parent_node
    parent_node.children << self
  end

  def add_child(child_node)
    unless @children.include?(child_node)
      child_node.parent = self
    end
  end

  def remove_child(child)
    raise Exception unless child.parent==self
    child.parent = nil
    self.children.delete(child)
  end

  def dfs(target_value)
    return self if self.value == target_value
    answer = nil
    self.children.each do |node|
      answer ||= node.dfs(target_value)
    end
    answer
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == target_value
      queue.concat(current_node.children)
    end
  end

end
