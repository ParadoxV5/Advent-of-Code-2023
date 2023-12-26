require_relative '../helpers/bsearch_indexer'

input = File.readlines('input.txt', chomp: true)

GALAXIES = []
empty_coords = [
  Array.new(input.fetch(0).size, &:itself), # x
  Array.new(input.size, &:itself) # y
]

input.each_with_index do|line, y|
  line.scan('#') do
    x = Regexp.last_match.begin(0)
    # Each galaxy
    GALAXIES << [x, y]
    empty_coords.fetch(0)[x] = empty_coords.fetch(1)[y] = nil
  end
end

EMPTY_COORD_INDEXERS = empty_coords.map { BsearchIndexer.new _1.compact }
input = empty_coords = [] # GC

# Strategy: Count the taxicab distance normally, account for the expansion separately.
taxicab_sum = empty_count = 0
GALAXIES.combination(2) do|set|
  set.transpose.each_with_index do|(o1, o2), i| # `[x1, x2, 0], [y1, y2, 1]`
    o2, o1 = o1, o2 if o1 > o2 # `Array#combination` does not specify order; `x`s aren’t ordered anyways
    taxicab_sum += o2 - o1
    empty_count += EMPTY_COORD_INDEXERS.fetch(i).size o1, o2
  end
end

puts(
  'Part 1', taxicab_sum + empty_count,
  'Part 2', taxicab_sum + empty_count * 999999
)
