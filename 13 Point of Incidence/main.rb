# After some observation and consideration,
# I determine that an optimized brute-force is good enough.
# Nearly all lines/columns are either unique or one of a unique mirror image pair.

# Set to `{}` to enable {Enumerable#tally} analysis
ANALYSIS = nil

def mirror_diff(matrix, idx_left, idx_right, &blk)
  until idx_left.negative? or matrix.size == idx_right
    matrix.fetch(idx_left).zip(matrix.fetch(idx_right)) { blk[_1, _2] unless _1 == _2 }
    idx_left  -= 1
    idx_right += 1
  end
  true
end

def reflection_index(matrix)
  ANALYSIS&.then { array.tally.each_value.tally _1 }
  matrix.each_index.each_cons(2).with_object(
    1 # Part 1: 0; Part 2: 1
  ) do|(idx_before, idx_after), differences_left|
    return idx_after if mirror_diff matrix, idx_before, idx_after do
      break if differences_left.zero?
      differences_left -= 1
    end and differences_left.zero?
  end
  nil
end

puts(
  File.foreach('input.txt', '', chomp: true).sum do|pattern|
    matrix = pattern.each_line(chomp: true).map(&:bytes)
    if (v_reflect_idx = reflection_index matrix)
      v_reflect_idx * 100
    else
      reflection_index matrix.transpose or 0
    end
  end
)

ANALYSIS&.then { warn _1 }
