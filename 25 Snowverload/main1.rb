# Huh … We had Cut Vertices in [Day 22](../22%20Sand%20Slabs/main.rb) Part 2, and now time for Cut Edges!
# https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm

NODES = Hash.new {|hash, name| hash[name] = {} }
File.foreach('input.txt') do|line|
  this, *neighbors = *line.scan(/\w++/).map { [_1.to_sym] }
  neighbors.each do|other|
    NODES[this][other] = NODES[other][this] = 1
  end
end
COUNT = NODES.size

until NODES.one?
  # warn NODES.size
  queue = NODES.transform_values { 0 }
  (t_label, t_weight), (s_label, s_weight) =
    NODES.reduce(Array.new(2, ['', {}])) do|(b, _a), _kv|
      max_key, = queue.max_by { _2 }
      queue.delete max_key
      max_weights = NODES.fetch max_key
      queue = queue.to_h {|key, value| [key, value + max_weights.fetch(key, 0)] }
      [[max_key, max_weights], b]
    end
  break $partition = t_label.size if t_weight.sum { _2 } <= 3 # As given by the puzzle
  
  NODES.delete s_label
  NODES.delete t_label
  s_weight.delete t_label
  t_weight.delete s_label
  # Note: don’t modify labels in-place – that messes up {Hash}’s {Object#hash}es
  st_label = s_label + t_label
  NODES[st_label] = s_weight.merge(t_weight) { _2 + _3 }.each do|other, combined|
    other_weights = NODES.fetch(other)
    other_weights.delete s_label
    other_weights.delete t_label
    other_weights[st_label] = combined
  end
end

puts $partition&.*(COUNT - $partition)
