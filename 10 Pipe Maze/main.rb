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

def follow(dir)
  x, y = S
  
  (1...MAX_ITERATIONS).each do|steps|
    x, y = step x, y, dir
    tile = FIELD.fetch(y)[x] # Note: `String does not have #dig method`
    return steps if 'S' == tile # looped back to the start
    return unless (dir = PIPES.dig tile, dir)
      # Check pipe char and validity; disqualify open path, already-traversed path or broken input
    FIELD.fetch(y)[x] = 'O' # erase the path so we don’t traverse the same loop twice
  end
  
  nil
end

puts(
  'Part 1',
  %i[N S W E].filter_map { follow _1 }.max&./(2) # `floordiv` 2 for half-loop
)
