# Let `d` be the distance to beat, `t` be the allowed time,
# and `s` be the time spent on charging the boat and thus the post-charge speed
# We have `(t-s)s > d ➡ ts - s² - d > 0`.
# The quadratic formula will get us the two `s`s where the expression crosses zero.
# ```
# a = -1, b = t, c = -d
# s = (-b ± √(b² - 4ac)) / 2a
#   = (-t ± √(t² - -4(-d))) / -2
#   = -t / -2 ± √(t² - 4d) / -2
#   = t / 2 ± √((t² - 4d) / (-2)²)
#   = t/2 ± √(t²/4 - d)
# ```
calculate =-> (race) do
  t, d = race.map(&:to_f)
  # Note: I don’t like using Floats, but here division by 2 is binary-precise
  mid = t / 2
  dev = Math.sqrt(t * t / 4 - d)
  #   (next_int(min)..prev_int(max)).size
  # = prev_int(max) - next_int(min) + 1
  # = (⌈max⌉ - 1) - (⌊min⌋ + 1) + 1
  # = ⌈max⌉ - 1 - ⌊min⌋ - 1 + 1
  # = ⌈max⌉ - ⌊min⌋ - 1
  (mid + dev).ceil - (mid - dev).floor - 1
end

input = File.foreach('input.txt').first(2).map { _1.scan /\d++/ }
puts(
  'Part 1',
  input.transpose.map(&calculate).inject(&:*),
  'Part 2',
  calculate.(input.map(&:join))
)
