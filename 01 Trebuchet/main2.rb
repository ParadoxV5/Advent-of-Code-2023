words = %w[\\d one two three four five six seven eight nine]
WORDS_INDEX = words.each_with_index.to_h
REGEXP = Regexp.new words.join('|') #=> /\d|one|…/

puts( File.foreach('input.txt').sum do|line|
  [
    line[REGEXP],
    (
      line.rindex(REGEXP)
      $&
    )
  ].map { WORDS_INDEX.fetch(_1, &:to_i) }.then { _1 * 10 + _2 }
end )
