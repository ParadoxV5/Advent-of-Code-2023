input = File.readlines('input.txt', chomp: true)

GALAXIES = []
EMPTY_COORDS = [
  Array.new(input.fetch(0).size, &:itself), # x
  Array.new(input.size, &:itself) # y
]

input.each_with_index do|line, y|
  line.scan('#') do
    x = Regexp.last_match.begin(0)
    # Each galaxy
    GALAXIES << [x, y]
    EMPTY_COORDS.fetch(0)[x] = EMPTY_COORDS.fetch(1)[y] = nil
  end
end

input = nil # GC
EMPTY_COORDS.each &:compact!

# Strategy: Count the taxicab distance normally, account for the expansion separately.
taxicab_sum = empty_count = 0
GALAXIES.combination(2) do|set|
  set << EMPTY_COORDS
  set.transpose.each do|o1, o2, empties| # `[x1, x2, empty_xs], [y1, y2, empty_ys]`
    o2, o1 = o1, o2 if o1 > o2 # `Array#combination` does not specify order; `x`s aren’t ordered anyways
    taxicab_sum += o2 - o1
    # Note: the `end` is exclusive because the `bsearch` is find-minimum (round up) for both edges
    empty_count += Range.new(
      *[o1, o2].map {|coord| empties.bsearch_index { _1 > coord } || empties.size },
      true # exclude_end
    ).size
  end
end

puts(
  'Part 1', taxicab_sum + empty_count,
  'Part 2', taxicab_sum + empty_count * 999999
)
