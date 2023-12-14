# It is no easy task to predict where the `O`s will roll without simulating, so we *have* to simulate for Part 2.
# 
# I expect the cycle to eventually loop. The `#`s are in their limbo positions for eternity,
# and next will be the `O`s closest to the `#`s, then the next closest, and so on.
# 
# Here, `y`-coordinates are in reverse order from `size` to `1` – matches the row’s load.

$round_rocks = []
input = File.foreach('input.txt', chomp: true)
spaces_by_x, spaces_by_y = Array.new(input.peek.size) { [] }, [[]]
input.reverse_each.with_index(1) do|row, y|
  spaces_by_y << row.each_char.filter_map.with_index do|char, x|
    unless '#' == char
      $round_rocks << [x, y] if 'O' == char
      spaces_by_x.fetch(x) << y
      x
    end
  end
end

SPACES_BY_COORD = [spaces_by_x, spaces_by_y].map do|spaces_by_coord|
  spaces_by_coord.map do|spaces_at_coord|
    spaces_at_coord.chunk_while { _1.succ == _2 }.map { _1.first.._1.last }
  end
end # `[SPACES_BY_X, SPACES_BY_Y]`
input = spaces_by_x = spaces_by_y = nil # GC

# def tilt_east
#   $round_rocks = $round_rocks.group_by { _2 }.flat_map do|y, array|
#     ys = array.map { _2 }
#     SPACES_BY_Y.fetch(y).map do|space|
#       space.last(ys.count { space.cover? _1 }).map {|x2| [x2, y] }
#     end
#   end
# end

# See main cycle code for examples
def tilt(coord_id, &slide_direction)
  axis_id = 1 - coord_id
  $round_rocks = $round_rocks.group_by {_1.fetch axis_id }.map do|coord, coords_array|
    coord_array = coords_array.map { _1[coord_id] }
    SPACES_BY_COORD.fetch(axis_id).fetch(coord).map do|space|
      slide_direction.(space, coord_array.count { space.cover? _1 }).map do|coord2|
        [coord, coord].tap { _1[coord_id] = coord2 }
      end
    end
  end.flatten(2)
end

# State of the {$round_rocks} (key) after some number of cycles (value) 
STATES = Hash.new
CYCLES = 1000000000
CYCLES.times do|time|
  # Arrays are more performant for {#tilt}ing,
  # but only sorted arrays (or {Set}s) are fit for duplicate detection.
  $round_rocks.sort!
  if (time0 = STATES[$round_rocks])
    #warn "Loop detected: #{time0} ⬅ #{time}"
    $round_rocks = (
      # 0        time0       time                        CYCLES
      # | pre-loop | 1st loop | remaining loops | post-loop |
      #            A B C D                      A   B   C   D
      STATES.key (CYCLES - time) % (time - time0) + time0 or raise 'savestate not found …?'
    )
    break
  end

  STATES[$round_rocks] = time
  tilt 1, &:last  # N: Y (1) ending
  tilt 0, &:first # W: X (0) beginning
  tilt 1, &:first # S: Y (1) beginning
  tilt 0, &:last  # E: X (0) ending
end

puts $round_rocks.sum { _2 }
