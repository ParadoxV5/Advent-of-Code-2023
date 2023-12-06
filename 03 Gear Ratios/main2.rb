# This time, we’ll scan the the schematic twice, first to identify gears.
# Although we __do__ double-count numbers shared by two gears for Part 2,
# it’s still much easier to check the surroundings of {String#scan}ed numbers
# than to seek variable-length number sequences around gears.
# (Take a look at `main2-regexp.rb` for the engineering required for insisting so.)
# It’s good that there aren’t a lot of gears for a hashmap to tally,
# so hopefully two-pass is about as efficient as a (vertical) sliding window like that of Part 1.
# After all, we need to keep tally of number counts and disqualify
# gears that don’t have __exactly__ two numbers, no more and no less.

INPUT = File.foreach('input.txt').with_index

GEARS = INPUT.flat_map do|line, y|
  line.each_char.with_index.filter_map {|char, x| [[x, y], []] if char == '*' }
end.to_h #: Hash[[Integer, Integer], Array[String]]

INPUT.each do|line, y|
  line.scan(/\d++/) do|num|
    # See comments regarding numbers beïng “up to 3 digits” on `main1.rb`.
    md = Regexp.last_match
    before = md.begin(0).pred # Don’t need to protect against `-1` index this time
    after = md.end(0)
    Enumerator.product(
      before..after, # `x`s
      [y.pred, y.succ] # `y`s
    ).chain([[before, y], [after, y]]).each { GEARS[_1]&.<< num }
  end
end

puts GEARS.each_value.sum { _1.size == 2 ? _1.map(&:to_i).inject(&:*) : 0 }
