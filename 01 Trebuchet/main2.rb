words = %w[\\d one two three four five six seven eight nine]
WORDS_INDEX = words.each_with_index.to_h
regexp_str = words.join('|')
REGEXP = Regexp.new regexp_str #=> /\d|one|…/
REGEXP_LAST = /.*(#{regexp_str}).*$/

puts( File.foreach('input.txt').sum do|line|
  [line[REGEXP], line[REGEXP_LAST, 1]]
    .map { WORDS_INDEX.fetch(_1, &:to_i) }
    .then { _1 * 10 + _2 }
end )
