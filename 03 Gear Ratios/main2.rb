GEARS = File.foreach('input.txt', chomp: true).with_index.flat_map do|row, y|
  row.each_char.with_index.filter_map {|char, x| [[x, y], []] if char == '*' }
end.to_h

File.foreach('input.txt', chomp: true).with_index do|row, y|
  row.scan(/\d+/) do|num|
    md = Regexp.last_match
    Enumerator.product(md.begin(0).pred..md.end(0), y.pred..y.succ).any? { GEARS[_1]&.<< num.to_i }
  end
end

puts GEARS.each_value.sum {|parts| parts.size == 2 ? parts.inject(&:*) : 0 }
