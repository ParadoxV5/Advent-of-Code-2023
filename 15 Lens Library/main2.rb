# How convenient, Ruby {Hash}es keep their insertion order
BOXES = Array.new(0x100) { {} }

File.foreach('input.txt', ',', chomp: true) do|step|
  /(?<label>.*)(=(?<focal>\d++)|-)/ =~ step
  box = BOXES.fetch label.each_byte.reduce(0) { (_1 + _2) * 17 & 0xFF }
  if focal
    box[label] = focal
  else
    box.delete label
  end
end

sum = 0
BOXES.each.with_index(1) do|box, box_number|
  box.each_value.with_index(1) do|focal, slot_number|
    sum += box_number * slot_number * focal.to_i
  end
end
puts sum
