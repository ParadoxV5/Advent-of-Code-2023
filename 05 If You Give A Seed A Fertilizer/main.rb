require_relative '../helpers/bsearch_indexer'

# Key Optimizations:
# * [Memory] After each almanac section, Process the `list` with the mappings,
#   then I’m done with the section and can discard it.
# * [Computation] Here’s the ingenuity: Rather than tracking begin and end values of several mapping {Range}s,
#   collect them into a flat associative list of exclusive end anchors. (Ends play nice with find-minimum `bsearch`.)
#   * The almanac `map`pings are are all continuous since every source number has a corresponding destination number,
#     either specified in the almanac or defaults to the same numbers. Observe that whichever is the case,
#     each source range correspond to one continuous destination range, though destination ranges may overlap. 
#   * This format allows quick identification from a given source range to its keyed source range
#     (in fact, `O(log n)` with find-minimum `bsearch` or, if your language has it, sorted maps!),
#     especially for Part 2 where we have to segment humongous ranges rather than map for specific numbers.
#   * This strategy asserts that the almanac source ranges do not overlap, lest there be ambiguity.

PART2 = true
File.open('input.txt') do|input|
  
  # Starts with the list of seeds and progressively {Array#map}s into the list of locations
  list = input.gets.scan(/\d++/).map(&:to_i)
  if PART2
    # `[src_begin, src_end]`
    list = list.each_slice(2).map { |src_begin, length| [src_begin, src_begin + length] }
  end
  input.each '' do|section| # Separate by blank line
    
    # Maps source **exclusive ends** to **source➡destination** deltas
    map = {} #: Hash[Integer, Integer]
    section.scan(/\d++/).each_slice(3) do|entry|
      dst_begin, src_begin, length = entry.map &:to_i
      map[src_begin] ||= 0 # __Don’t__ overwrite previous explicit positive if any
      map[src_begin + length] = dst_begin - src_begin # __Do__ overwrite previous implicit negative if any
    end
    section.clear # Done with it; GC
    map_keys = map.each_key.sort
    map_indexer = BsearchIndexer[map_keys]
    
    if PART2
      # `src`: ___)___)___)___)___)
      # `num`:  [_______)     [___)_)
      # merge:  [_)___)_)      [__)_)
      #         A B   C D     X   Y Z
      list = list.flat_map do|num_begin, num_end|
        [
          num_begin,
          *map_indexer[num_begin, num_end],
          num_end
        ].each_cons(2).map do|src_range|
          map.fetch(src_range.last) do|src_end|
            map[map_keys.bsearch { _1 > src_end }]
          end&.then {|delta| src_range.map! { _1 + delta } }
          src_range
        end
      end
      # Simplification of the resulting list is left as an exercise of the viewer.
      # (it’s not needed for this challenge and likely not intended to be part of it.)
      
    else
      list.map! do|num|
        map.fetch(num) { map[map_keys.bsearch { _1 > num }] }&.then { num += _1 }
        num
      end
    end
  end
  
  list.map!(&:first) if PART2
  puts list.min
end
