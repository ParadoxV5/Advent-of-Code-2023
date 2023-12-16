# Ah yes, [Chromatron](https://silverspaceship.com/chromatron)

# Reading how the story goes, I bet Part 2 will task us to adjust *something* to maximize light coverage.
# Will we have to compute the number of adjustments to fill the entire grid? Hopefully not.
# Howëver, depending on the adjustment type(s) and the amount of maximizing demanded,
# it might be easier to trace from the tiles rather than the lightbeam!
# We don’t know yet though, so I’ll stick to the intuitive strat for now.
# Hey, even if Part 2 ends up trolling us, implementing it both ways is still fun and challenging!

# Keep line breaks and trailing empty string as paddings for out-of-bounds protection
INPUT = File.readlines 'input.txt'
# To prevent counting twice most easily (and most performant), I track the energized tiles with a boolean table.
# A previous iteration is a hashset – optimized by indexing one coordinate.
ENERGIZED = INPUT.map { Array.new(_1.size.pred, false) }
INPUT << ''

# To prevent there having too many split light to track, I will only follow one path at a time.
# * If the current path flies off-grid, it’s time to trace the next branch.
# * If the current path returns to a previous splitter …
#   * … and will be split the same old way (i.e., coming from the other direction†),
#     I stop here since I’ll eventually tracing it with my backtracking anyways. 
#   * … but now in the (other†) parallel direction and is about to loop itself,
#     I recon that I have just traversed the untracked end early and remove it from the queue.
#   † How is it guaranteed? The logic is left as an exercise for the reader.
# I implement both cases by not traversing any splitters flagged in {ENERGIZED_BY_Y}.
# 
# [Update] The idea of using {ENERGIZED_BY_Y} booleans to flag traversal progress turns out not actually
# stopping repetitions, but it _does_ limit loops to a couple of repeats thanks to implementation details.
# I analyzed the possibilities and found that prevention is no simple task, so I decided to let what I have lie.
# After all, Part 2 indeed turns out better done with the opposite approach of intuition
# __and also can fit a Part 1 reimplementation inside__, so I’ll reinvest there instead.

# Depth-first search, you might call it
beams = [[0, 0, false, 1]]
until beams.empty?
  beams2 = []
  beams.each do|x, y, dir_is_y, dir_vector|
    loop do
      split = nil
      case INPUT[y][x]
      in '.'
        # no-op other than the common stuff
      in '|' | '-' if ENERGIZED.dig y, x
        break # Already traversed? DRY then.
      in '|' if dir_is_y
        # as if empty space
      in '-' unless dir_is_y
        # ditto
      in '|' | '-' # Perpendicular: split
        dir_is_y = !dir_is_y
        split = [x, y, dir_is_y, -dir_vector]
      in '/'
        dir_is_y = !dir_is_y
        dir_vector = -dir_vector
      in '\\'
        dir_is_y = !dir_is_y
      else # Already-traversed splitter, `\n` from off-grid, or corrupt input
        break
      end
      if split
        beams2 << split # {Enumerator} + {StopIteration}? Maybe, but that’s incomprehensible, so I didn’t bother.
      else # If splitting, let another (not necessarily _the_ other (; ) traversal mark the splitter.
        ENERGIZED.fetch(y)[x] = true
      end
      dir_is_y ? y += dir_vector : x += dir_vector
    end
  end
  beams = beams2
end

puts ENERGIZED.sum { _1.count(&:itself) }
