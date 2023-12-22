# https://minecraft.wiki/w/Sandstone_Slab

Slab = Data.define(*%i[x1 y1 z1 x2 y2 z2]) do
  # Check if the two rectangles *don’t* overlap if excluding the Z dimension
  def independent?(other) =
    x1 > other.x2 || x2 < other.x1 || y1 > other.y2 || y2 < other.y1
  def drop_on?(other)
    unless independent? other
      z1 = other.z2.succ
      with(z1:, z2: z2 - self.z1 + z1)
    end
  end
end

STACK = [Slab.new(0, 0, 0, 9, 9, 0)] # Initialize with a ground
File.foreach('input.txt')
  .map { Slab.new *_1.scan(/\d++/).map(&:to_i) }
  .sort_by!(&:z1) # I don’t think {Slab#z1} vs. {Slab#z2} matters here
  .each do|slab|
    # It’s more a Jenga than a pile, so linear is more efficient than {Array#bsearch}  
    STACK.reverse_each.find do|other|
      # Ensure the {STACK} is sorted by {Slab#z2} (if only there is “sorted list”…)
      if (slab2 = slab.drop_on? other)
        STACK.insert STACK.rindex { _1.z2 <= slab2.z2 }&.succ || 0, slab2
      end
    end
  end

STACK_BY_Z2 = STACK.group_by(&:z2)
puts(
  STACK.size - STACK.filter_map do|slab|
    # A slab is unsafe to disintegrate if there are slabs that sit on it and only it.
    sits_on, not_exactly_one =
      STACK_BY_Z2[slab.z1.pred]&.reject { slab.independent? _1 or slab.equal? _1 }
    sits_on unless not_exactly_one
  end.uniq.size
)
