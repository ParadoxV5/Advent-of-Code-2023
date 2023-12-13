# After some observation and consideration,
# I determine that an optimized brute-force is good enough.
# Nearly all lines/columns are either unique or one of a unique mirror image pair.

# Set to `{}` to enable {Enumerable#tally} analysis
ANALYSIS = nil


#@type method reflection_index: (Array[top] array) -> Integer?
def reflection_index(array)
  ANALYSIS&.then { array.tally.each_value.tally _1 }
  
  (1..array.size / 2)
    .then { _1.chain _1.reverse_each }
    .with_index(1)
    .find do|mirror_size, index|
      before = array[index - mirror_size...index]
      after  = array[index...mirror_size + index]
      before == after.reverse
    end&.last
end

puts(
  File.foreach('input.txt', '', chomp: true).sum do|pattern|
    array = pattern.lines(chomp: true)
    if vertical_reflection_index = reflection_index(array)
      vertical_reflection_index * 100
    else
      reflection_index(array.map(&:bytes).transpose) || 0 
    end
  end
)

ANALYSIS&.then { pp _1 }
