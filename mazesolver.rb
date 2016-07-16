class MazeSolver

end





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
