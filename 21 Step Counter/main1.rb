# Observe the example map. Notice how reachable `O`s and unreachable `.`s form a checkerboard pattern.
# The reason is simple: Once he reach a plot, he can waste all of his remaining steps in pairs by pacing back and forth.

#@type const GARDEN: Array[Array[boolish]]
GARDEN = File.foreach('input.txt').with_index.map do|line, y|
  # Keep line breaks for out-of-bounds padding
  line.each_char.with_index.map do|position, x|
    #noinspection RubyCaseWithoutElseBlockInspection
    case position
    when '.'
      true
    when 'S'
      Y_S, X_S = y, x
    end
  end
end << [] # out-of-bounds padding

# Your plain o’ BFS Flood Fill
# Note: For {Array#dig}’s convenience, coordinates are in **y-x** pairs here
64.times.reduce(VISITED = Set[[Y_S, X_S]]) do|queue, _i|
  queue.flat_map {|y, x| [
    [y.pred, x],
    [y.succ, x],
    [y, x.pred],
    [y, x.succ]
  ] }.to_set.keep_if { GARDEN.dig *_1 and VISITED.add? _1 }
end

# Can only reach even distances from even steps
def parity(y, x) = (y ^ x) & 1
parity_s = parity(Y_S, X_S)
puts VISITED.count { parity_s == parity(_1, _2) }
