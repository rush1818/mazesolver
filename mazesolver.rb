require 'byebug'
require './treenode'
class MazeSolver
  attr_reader :maze, :seen_positions
  def initialize(filename)
    lines = File.readlines(filename).map(&:chomp).map
    @maze = lines.map{ |l| l.split("")}
    @start_position = coord_of_start_end(@maze, "S")
    @start_node = PolyTreeNode.new(@start_position)
    @end_position = coord_of_start_end(@maze, "E")
    @seen_positions = []
    @position_nodes = [@start_node]
  end

  def [](pos)
    r, c = pos
    @maze[r][c]
  end

  def []=(pos, val)
    r,c = pos
    @maze[r][c] = val
  end

  def row_count
    @maze.length
  end

  def col_count
    @maze[0].length
  end

  def in_maze?(pos)  #is position within the maze?
    rows = @maze.length
    cols = @maze[0].length
    pos[0].between?(0, rows - 1) && pos[1].between?(0, cols - 1)
  end

  def is_wall?(pos)
    self[pos] == "*"
  end

  def coord_of_start_end(grid, mark)
    row, col = 0, 0
    grid.each_with_index do |line, id1|
      line.each_with_index do |el, id2|
        if el == mark
          row = id1
          col = id2
        end
      end
    end
    [row, col]
  end

  def find_adjacent(pos)
    # byebug
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    adjacent_positions = directions.map{|dir| [dir[0]+pos[0], dir[1]+pos[1]] }
    adjacent_positions.select{|new_pos| !is_wall?(new_pos) && in_maze?(new_pos)}
  end

  def populate_available_position_nodes
    #populates all positions from START that are empty using BFS
    queue = [@start_node]
    until queue.empty?
      current_node = queue.shift
      adjacent_positions = find_adjacent(current_node.value)
      adjacent_positions.reject! { |pos| @seen_positions.include?(pos) }
      @seen_positions.concat(adjacent_positions)
      adjacent_positions.each do |pos|
        child = PolyTreeNode.new(pos)
        child.parent = current_node
        @position_nodes << child
        queue << child
      end
    end

  end

  def build_tree

  end



end



p "*" * 15
m = MazeSolver.new('maze1.txt')
# p m.in_maze?([-1, -1])
# p m.in_maze?([100, 100])
# p m.in_maze?([5, 5])
# p m.row_count
# p m.col_count
# p m.in_maze?([8, 16])
# p m.in_maze?([7, 16])
# p m.in_maze?([7, 15])
p "*" * 15
p "adjacent_positions"
# p m.find_adjacent([2,3])
p m.populate_available_position_nodes
p m.seen_positions

=begin

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    puts "Enter file name as maze1.txt"
    file = gets.chomp
    game = MazeSolver.new(file)
    game.play
  else
    game = MazeSolver.new(ARGV[0])
    game.play
  end
end
=end
