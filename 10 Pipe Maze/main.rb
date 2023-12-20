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
    line[x] = '$' # conflicts with `:S`
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

# Part 1
(upcase, downcase), steps = %i[N S W E].to_h do|dir|
  x, y = S
  [
    [
      upcase = dir.to_s,
      downcase = upcase.downcase
    ],
    
    (1...MAX_ITERATIONS).lazy.filter_map do|step|
      x, y = step x, y, dir
      
      tile = FIELD.fetch(y)[x] # Note: `String does not have #dig method`
      if (dir = PIPES.dig tile, dir) # Check pipe char and validity
        # Mark on the {FIELD} in preparation for Part 2
        FIELD.fetch(y)[x] = '-' == tile ? downcase : upcase
        nil # continue looping
      elsif '$' == tile # looped back to the start
        step # length of the whole loop
      else
        0 # Disqualify open path, already-traversed path or broken input
      end
    end.first || -1
  ]
end.max_by { _2 }

#warn FIELD

puts(
  'Part 1',
  steps / 2 # `floordiv` 2 for half-loop
)
