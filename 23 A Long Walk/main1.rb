# Heh, ain’t everyday we get to solve a *longest path problem*. Explicitly-given conveniences:
# * We have a definite start and end
# * We count in steps – simple BFS, or rather, DFS will do.

MAZE = File.foreach('input.txt', chomp: true).map { _1.each_char.map(&:to_sym) }
  # The maze has outer walls.
Y_MAX = MAZE.size.pred

DIRECTIONS = {
  'v': [ 0, +1],
  '>': [+1,  0],
  '^': [ 0, -1],
  '<': [-1,  0]
}

VISITED = Set.new
$max = 0
def dfs(x, y, direction)
  here = MAZE.fetch(y)[x]
  return unless :'.'.equal? here or direction.equal? here
  if Y_MAX.equal? y
    $max = VISITED.size if VISITED.size > $max
  else
    return unless VISITED.add?(xy = [x, y])
    DIRECTIONS.each {|direction2, (dx, dy)| dfs x+dx, y+dy, direction2 }
    VISITED.delete xy
  end
end

dfs 1, 0, 'v'
puts $max
