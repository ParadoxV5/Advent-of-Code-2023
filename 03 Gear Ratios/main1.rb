PARTS = File.foreach('input.txt', chomp: true).with_index.flat_map do|row, y|
  row.each_char.with_index.filter_map {|char, x| [x, y] unless char.match? /[\d .]/ }
end.to_set

sum = 0
File.foreach('input.txt', chomp: true).with_index do|row, y|
  row.scan(/\d+/) do|num|
    md = Regexp.last_match
    sum += num.to_i if Enumerator.product(md.begin(0).pred..md.end(0), y.pred..y.succ).any? { PARTS.include? _1 }
  end
end
puts sum
