# Seeking numbers around gears is more difficult due to their variable-length nature.
# But – it makes a fine challenge for {Regexp} engineering!
# Of course, the longer the schematic lines, the less efficient this strategy gets.
# For fun only – may not suit production.

# Same limitation as in Part 1
sum = 0

# Padded sliding window just like Part 1
Enumerator::Chain.new(
  dummy_lines = [''],
  File.foreach('input.txt'),
  dummy_lines
).each_cons(3) do|pred, line, succ|
  # Might as well scan for neighboring numbers on the same line while we’re scanning for `*`s
  line.scan(/
    (\d+)? # `prefix_num`
    \K     # Match Reset – have `Regexp.last_match` disregard `prefix_num` …
    \*     # … so `x` is the index of the `*` literal rather than that of `prefix_num`
    (\d+)? # `suffix_num`
  /x) do|affix_nums| # [prefix_num, suffix_num]
    affix_nums.compact! # Don’t want `nil`s for non-matches
    x = Regexp.last_match.begin(0)
    [pred, succ].each do|line2|
      # {String#scan} because a `line2` can have 2 neighboring numbers:
      # ```
      #    *
      # …89 12…
      # ```
      affix_nums.push *line2.scan(/
        # ```
        #     12…
        #    * %
        # …89
        # ```
        (?<!          # Negative Lookbehind
          .{#{x + 2}} # `x + 2` chars
        )             # Ensure it isn’t at least 2 after the index of `*` (labelled `%`) when the number starts
        \d+
        (?<=          # Positive Lookbehind
          .{#{x}}     # `x` chars
        )             # Ensure it is at least the index of `*` after the number ends
      /x)
    end
    sum += affix_nums.map(&:to_i).inject(&:*) if affix_nums.size == 2
  end
end

puts sum
