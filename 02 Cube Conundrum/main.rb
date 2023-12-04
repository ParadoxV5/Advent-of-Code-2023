PART2 = true

puts(
  File.foreach('input.txt').sum do|game|
    tally = Hash.new(0) #: Hash[String, Integer]
    game.split(';') do|game|
      tally.merge!(
        game.scan(/(\d+) (\w+)/).to_h {|count, color| [color, count.to_i] }
      ) {|_color, old, new| [new, old].max }
    end
    
    if PART2
      tally.each_value.inject &:*
      
    elsif { # Part 1
      'red' => 12,
      'green' => 13,
      'blue' => 14
    }.any? {|color, limit| tally[color] > limit }
      0
    else
      game[/\d+/].to_i
    end
  end
)
