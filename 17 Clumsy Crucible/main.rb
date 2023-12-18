# Your generic shortest-path problem with a couple of (literal?) twists. Time for good o’ Dijkstra’s to shine again!
# Note: I even learned [A*](https://en.wikipedia.org/wiki/A*_search_algorithm) at one point,
# but much thought has determined that there are no worthy heuristics.
# 
# To account for *the twists*, we traverse the available number of blocks at a time and force the next
# traversal to change axis (turn 90°) (also solves Part 2’s “before it can stop at the end” problem).

INPUT = File.foreach('input.txt', chomp: true).map do|line|
  line.each_byte.map { _1 & 0x0F } # 0x30.chr => '0'
end

x_size = INPUT.fetch(0).size
y_size = INPUT.size
X_DEST = x_size.pred
Y_DEST = y_size.pred

# `{[x, y, d] => distance}` (`d` means x/y alignment. Which predicate exactly? IDK either `¯\_(ツ)_/¯`.)
# 
# If the {Set} is implemented with a {Hash},
# caching estimates for convenience here not only doesn’t waste memory but also might even improve performance.
TO_TRAVERSE = y_size.times.map do|y|
  x_size.times.map do|x|
    [
      [[x, y, 0], Float::INFINITY],
      [[x, y, 1], Float::INFINITY]
    ]
  end
end.flatten(2).to_h # 3D matrix `<.<`
TO_TRAVERSE[[0, 0, 0]] = TO_TRAVERSE[[0, 0, 1]] = 0


PART2 = true
NEIGHBORS_ENUMERATOR = (PART2 ? 11 : 4).times.each_cons(2)
  # `0..10`/`0..4`; the extraneous beginning portions are mere helper values …

puts(
  until TO_TRAVERSE.empty?
    key, distance = TO_TRAVERSE.min_by { _2 }
    x, y, d = key
    break distance if X_DEST.equal? x and Y_DEST.equal? y
    TO_TRAVERSE.delete key
    d ^= 1 # `d1` is not used
    
    neighbors = {} #: Hash[Integer, [known_distance, Integer, Integer]]
    NEIGHBORS_ENUMERATOR.each do|step_pair|
      [step_pair, step_pair.map(&:-@)].each do|prerequisite_step, step|
        x2, y2 = x, y
        underflow = if d.odd?
          x2 += step
          x2.negative?
        else
          y2 += step
          y2.negative?
        end
        if !underflow and weight = INPUT.dig(y2, x2)
          if (prerequisite_weight, = neighbors[prerequisite_step])
            weight += prerequisite_weight
          end
          neighbors[step] = [weight, x2, y2]
        end
      end
    end
    neighbors = neighbors.except(3, 2, 1, -1, -2, -3) if PART2
    
    neighbors.each_value do|distance2, x2, y2|
      key2 = [x2, y2, d]
      TO_TRAVERSE[key2] = distance2 if TO_TRAVERSE[key2]&.>=(distance2 += distance)
    end
  end
)
