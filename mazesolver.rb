require 'byebug'
require 'colorize'
require './treenode'

class MazeSolver
  attr_reader :end_position
  def initialize(filename, use_dfs = true)
    @use_dfs = true
    lines = File.readlines(filename).map(&:chomp).map
    @maze = lines.map{ |l| l.split("")}
    @start_position = coord_of_start_end(@maze, "S")
    @start_node = PolyTreeNode.new(@start_position)
    @end_position = coord_of_start_end(@maze, "E")
    @seen_positions = []
    @position_nodes = [@start_node]
    render
  end

  def render
    sleep(0.1)
    system('clear')
    @maze.each do |row|
      puts row.join("  ")
    end
    #p "                   "

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

  def find_path(end_pos)
    populate_available_position_nodes
    # @visited_positions.each
    if @position_nodes.none?{|node| node.value == @end_position}  #if no paths exist the stop early
      puts "No paths available".colorize(:color => :white, :background => :red)
      abort
    end

    return trace_path_back(@start_node.dfs(end_pos)) if @use_dfs
    return trace_path_back(@start_node.bfs(end_pos)) unless @use_dfs

    #returns an array path
  end
  def trace_path_back(target_node)
    path = []

    if target_node.parent.nil?
      path << target_node.value
    elsif target_node.parent != @start_position
      path << target_node.value
      path.concat(trace_path_back(target_node.parent))
    else
      path << target_node.parent
    end

    path
  end


  def solve
    path = find_path(@end_position).reverse
    path.each do |pos|
      self[pos] = "o".colorize(:color => :light_blue) unless self[pos] == "E" || self[pos] == "S"
      render
    end
  end



end





if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    game = MazeSolver.new('maze1.txt')
    game.solve
  else
    game = MazeSolver.new(ARGV[0], ARGV[1])
    game.solve
  end
end
