# Find the next term of a polynomial sequence of unknown degrees from given terms…
# The given algorithm does just fine and is also the suggestion from several Google results.
# Them Bachelors of Calculus might have another trick up their sleeves – not us. We’re at most Computer Scientists.

# @type method extrapolate: (Array[Integer]) -> [Integer, Integer]
def extrapolate(sequence)
  first = sequence.first
  if sequence.all? { first.eql? _1 }
    [first, first]
  else
    d_first, d_last = extrapolate sequence.each_cons(2).map { _2 - _1 }
    [first - d_first, sequence.last + d_last]
  end
end

extrapolations = File.foreach('input.txt').map { extrapolate _1.split.map(&:to_i) }
puts(
  'Part 1', extrapolations.sum(&:last),
  'Part 2', extrapolations.sum(&:first)
)
