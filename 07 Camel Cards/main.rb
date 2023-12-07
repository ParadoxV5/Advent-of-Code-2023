PART2 = true

ORDER = (PART2 ? 'J23456789TQKA' : '23456789TJQKA').each_char.with_index.to_h

puts(
  File.foreach('input.txt').map(&:split).sort_by! do|hand, _bid|
    cards = hand.each_char
    tally = cards.tally
    
    jokers = if PART2 and tally.size > 1 # `> 1` protects against `JJJJJ` cheater hand
      tally.delete 'J'
    end
    
    [
      tally.each_value.sort.reverse.tap { _1[0] += jokers if jokers },
      cards.map(&ORDER)
    ]
  end.each_with_index.sum {|(_hand, bid), index| bid.to_i * index.succ }
)
