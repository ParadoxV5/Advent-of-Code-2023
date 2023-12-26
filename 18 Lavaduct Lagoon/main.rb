# Hah, another “find the area of a polygon” ([Day 10](../10 Pipe Maze/main.rb) Part 2, remember?)
# Unfortunately, the lagoon is too huge for the Even-Odd Rule Algorithm (which, to be fair, is brute-force),
# so we need an alternate algorithm.
# 
# Assuming no 0° and 360° turns, the input file naturally marks out the vertices of the lagoon polygon.
# The formula doesn’t work if the trench crosses over itself and the diggers clear out both holes,
# While not specified, my input doesn’t look like having such *edge* case,
# and I assume the elves won’t bother digging that strangely either.
# In contrast, Day 10’s pipes have no pieces (other than `S`, maybe) that support intersections.

require_relative '../helpers/area_from_vertices'

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

puts area_from_vertices VERTICES, PERIMETER
