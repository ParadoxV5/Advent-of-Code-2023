sum = 0
# Transpose the input so it’s easier to {String#scan}
File.readlines('input.txt', chomp: true).map(&:bytes).transpose.each do|column|
  column.pack('C*') # {Array#pack} the byte array to a String
    # The immobile `#`s divide the column into `chunk`s in which the `O`s can roll.
    .scan /[^#]++/ do|chunk|
      # Observe: `load = size - index`.
      # The first `O` will roll to the first index available in the chunk …
      load = column.size - Regexp.last_match.begin(0)  
      # … and subsequent `O`s will roll to the subsequent indices.
      # Note: There are very few `O`s in each `chunk`.
      # The Arithmetic Series formula will often be even less efficient.
      chunk.count('O').times do
        sum += load
        load -= 1
      end
  end
end
puts sum
