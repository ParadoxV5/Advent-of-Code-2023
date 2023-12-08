PART2 = true
VALIDATE = true

File.open('input.txt') do|input|
  INSTRUCTIONS = input.gets('', chomp: true).each_char.map { 'LR'.index _1 }
  NETWORK = input.each_line.to_h { _1.scan(/\w++/).then {|a| [a.shift, a] } }
end

# Apparently, the gamemaster is intentionally giving us inputs where, for each `A` node `Aₗ`,
# after taking `nₗ` steps to reach its first `Z` node `Zₗ`, `nₗ` steps more and it’s back to the same node `Zₗ`.
# I don’t like utilizing unspecified patterns (for practical editions, that is, e.g. outside ⛳),
# but with the results in dozens of trillions, I suppose I’ll let it lie.
# Future me might have an interest to come back to this and deduce on some general cases.

puts(
  (PART2 ? NETWORK.each_key.select { _1.end_with? 'A' } : %w[AAA]).map do|here|
    INSTRUCTIONS.cycle.with_index do|instruction, count|
      break count if here.end_with? 'Z'
      here = NETWORK.dig here, instruction
    end.tap do|count|
      if VALIDATE
        if PART2
          there = here
          count.times.zip(INSTRUCTIONS.cycle) do|_count, instruction|
            here = NETWORK.dig here, instruction
            break if here.end_with? 'Z'
          end
          raise "Path to `#{there}` does not repeat itself (landed on `#{here}` instead)" unless there == here
        else
          raise "`AAA` leads to `#{here}` rather than `ZZZ`" unless 'ZZZ' == here
        end
      end
    end
  end.inject(&:lcm)
)
