# Hah, another “find the area of a polygon” (Day 10 Part 2, remember?)
# Unfortunately, the lagoon is too huge for the Even-Odd Rule Algorithm (which, to be fair, is brute-force),
# so we need an alternate algorithm.
# 
# Assuming no 0° and 360° turns, the input file naturally marks out the vertices of the lagoon polygon.
# A quick Google search of `area of polygon from vertices` gets us [Gauss's area formula](https://en.wikipedia.org/wiki/Shoelace_formula).
# Day 10 Part 2 is also solvable with the new formula, but for that one, I’m sticking with my independent idea ’til the bitter end.
# 
# The formula doesn’t work if the trench crosses over itself and the diggers clear out both holes,
# but neither does the Even-Odd Rule Algorithm. While not specified, my input doesn’t look like having such *edge* case,
# and I assume the elves won’t bother digging that strangely either.
# In contrast, Day 10’s pipes have no pieces (other than `S`, maybe) that support intersections.

x = y = 0
VERTICES = [[x, y]]

PERIMETER = File.foreach('input.txt').sum do|line|
  direction, meters, color = line.split
  if (part2 = true)
    direction = color[~1]
    meters = color[2, 5].hex
  else
    meters = meters.to_i
  end
  case direction
  when 'U', '3'
    y -= meters
  when 'D', '1'
    y += meters
  when 'L', '2'
    x -= meters
  when 'R', '0'
    x += meters
  end
  VERTICES << [x, y]
  meters
end
# Note: the input cycles back to `[0, 0]` at the end.

# * Trapezoid formula
# * Just the textbook formula isn’t enough since only exactly half of the trench is counted.
#   * Each edge of the polygon has ½ of the block not counted.
#   * Simply counting edges up also overcounts by ¼ for every 270° corner.
#   * Each 90° corner also has ¼ of a block not counted.
#   * In order for the polyline to loop itself, it must have turned exactly 360°.
#     This can only come from 4 more 90°s than there are 270° turns.
puts (VERTICES.each_cons(2).sum {|(x1, y1), (x2, y2)| (x1 - x2) * (y1 + y2) }.abs + PERIMETER) / 2 + 1
