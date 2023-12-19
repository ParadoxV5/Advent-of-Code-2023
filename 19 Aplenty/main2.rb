# Arbitrary Code Execution was fun, but Part 2 is better done traditional.
WORKFLOWS = {}

File.foreach('input.txt', chomp: true) do|line|
  break if line.empty?
  workflow, *rules, default = line.split(/[{:,}]/)
  WORKFLOWS[workflow] = [
    rules.each_slice(2).map do|condition, value|
      category, operator, criterion = condition.split('', 3)
      [
        category.to_sym,
        criterion.to_i,
        '<' == operator, # is_less
        value
      ]
    end,
    default
  ]
end

# FYI, both parts use the same DFS.
def count(part_range, workflow)
  case workflow
  when 'A'
    # Predicates in the `else` branch ensures `max >= min`
    part_range.each_value.map { _2.succ - _1 }.inject(&:*)
  when 'R'
    0
  else
    
    criteria, default = WORKFLOWS.fetch workflow
    sum = 0
    criteria.each do|category, criterion, is_less, workflow2|
      min, max = range = part_range.fetch(category)
      positive, negative = if is_less
        if    criterion <= min then [nil, range]
        elsif criterion >  max then [range, nil]
        else [[min, criterion.pred], [criterion, max]]
        end
      else
        if    criterion >= max then [nil, range]
        elsif criterion <  min then [range, nil]
        else [[criterion.succ, max], [min, criterion]]
        end
      end
      if positive
        sum += count(part_range.merge(category => positive), workflow2)
        # Don’t need to check no-more-non-matches if there is no match
        if negative
          part_range[category] = negative
        else # No more possibilities to iterate the remaining criteria with
          return sum
        end
      end
    end
    sum + count(part_range, default)
  end
end

puts count %i[x m a s].to_h { [_1, [1, 4000]] }, 'in'
