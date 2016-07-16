class MazeSolver
  attr_reader :maze
  def initialize(filename)
    lines = File.readlines(filename).map(&:chomp).map
    @maze = lines.map{ |l| l.split("")}
    @start_position = coord_of_start_end(@maze, "S")
    @end_position = coord_of_start_end(@maze, "E")
    @available_moves = []
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

end

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
