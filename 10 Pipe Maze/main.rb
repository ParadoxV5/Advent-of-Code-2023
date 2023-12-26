# I was originally stuck on Part 2 until I decided to do some research for
# [Day 18](18 Lavaduct Lagoon/main.rb) which has the exact same type of problem.
require_relative '../helpers/area_from_vertices'

PIPES = {
  '|' => {N: :N, S: :S},
  '-' => {W: :W, E: :E},
  'L' => {S: :E, W: :N},
  'J' => {S: :W, E: :N},
  '7' => {N: :W, E: :S},
  'F' => {N: :E, W: :S}
}

# Keep line breaks and trailing empty string as paddings for out-of-bounds protection
FIELD = File.readlines('input.txt') << ''
FIELD.each_with_index do|line, y|
  if (x = line.index 'S')
    break S = [x, y]
  end
end

# Infinite loop protection
MAX_ITERATIONS = FIELD.size * FIELD.fetch(0).size

def step(x, y, dir)
  case dir
  when :N
    y -= 1
  when :S
    y += 1
  when :W
    x -= 1
  when :E
    x += 1
  else
    return nil
  end
  [x, y]
end

def follow(starting_direction)
  corners = []
  x, y = S
  dir = starting_direction
  
  (1...MAX_ITERATIONS).each do|length|
    x, y = step x, y, dir
    tile = FIELD.fetch(y)[x] # Note: `String does not have #dig method`
    if 'S' == tile # looped back to the start
      corners << S unless starting_direction.equal? dir
      return [corners, length]
    end
    return unless (dir = PIPES.dig tile, dir)
      # Check pipe char and validity; disqualify open path, already-traversed path or broken input
    corners << [x, y]  unless '|-'.include? tile
    FIELD.fetch(y)[x] = 'O' # erase the path so we don’t traverse the same loop twice
  end
  
  nil
end

if (corners, perimeter = %i[N S W E].filter_map { follow _1 }.max_by { _2 })
  puts(
    'Part 1', # Semi-perimeter
    perimeter / 2, # `floordiv` 2 for half-loop
    'Part 2', # Area
    area_from_vertices(corners, -perimeter)
  )
end
