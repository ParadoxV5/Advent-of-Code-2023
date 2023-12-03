# We don’t want to count a number twice if two parts happens to share the number,
# so we simply check which numbers to sum up and which to disregard.
# The popular strategy scans the schematic twice, once to identify parts and once for the numbers.
# But note that it’s only as efficient as the (vertical) sliding window employed here, if not less.
# After all, both strategies validate numbers by checking their entire surrounding, only different methods.


def part?(str) = str&.match? /[^.\d]/

# Can’t `String.scan(/…/).sum { …do_something_with_matchdata… }`
# because {String#scan} returns an `Array[String]` rather than a `Enumerable`
sum = 0

Enumerator::Chain.new(
  dummy_lines = [''], # Padding for the sliding window {Enumerable#each_cons}
  File.foreach('input.txt', chomp: true),
  dummy_lines
).each_cons(3) do|pred, line, succ|
  line.scan(/\d+/) do|num|
    md = Regexp.last_match
    # The match is at indices {MatchData#begin}**`...`**{MatchData#end}.
    # Here we’d like the `begin` be exclusive just like the `end`
    before = md.begin(0)
    before -= 1 if before.positive? # Protect against `-1` index
    after = md.end(0)
    # We test for positive so `nil&.…` short circuits to negative
    sum += num.to_i if
      part? line[after]  or
      part? line[before] or
      part? pred[before..after] or
      part? succ[before..after] # `[…].any?…` but with lazy candidates
  end
end

puts sum
