# You may utilize the tabular format of fixed number, `:` and/or `|` indices;
# I just minimize unspecified things (i.e., UB) whenever I don’t have to.

PART2 = true

EXTRAS_QUEUE = [] if PART2

puts(
  File.foreach('input.txt').sum do|line|
    win_count = line.split(/[|:]/)
      .tap(&:shift) # The card number is not used in either part of the puzzle
      .map { _1.scan /\d++/ }
      .then {|win_numbers, numbers| numbers.count { win_numbers.include? _1 } }
    
    if PART2
      (
        EXTRAS_QUEUE.shift&.succ || 1 # + 1 original copy
      ).tap {|copies| win_count.times do|i_next|
        EXTRAS_QUEUE[i_next] = EXTRAS_QUEUE[i_next]&.+(copies) || copies
      end }
      
    else
      win_count.zero? ? 0 : 1 << win_count.pred
    end
  end
)
