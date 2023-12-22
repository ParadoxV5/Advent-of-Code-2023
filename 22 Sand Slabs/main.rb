# https://minecraft.wiki/w/Sandstone_Slab

Slab = Struct.new(*%i[x1 y1 z1 x2 y2 z2]) do
  attr_reader :sits_on
  def initialize(...)
    @sits_on = []
    super
  end
  
  # `other` explicitly hard carries `self` if `self` {#sits_on} `other` and only `other`.
  # This is that hard carrying slab, or `nil` if `self` `sits_on` other slabs too.
  # A slab is unsafe to disïntegrate if it hard carries one or more slabs.
  attr_reader :hard_carried_by
  def sits_on=(others)
    @sits_on = others
    @hard_carried_by = (others.first if others.one?) # It’s not a hard carry if more than one supports it.
    #@all_hard_carried_by = nil # Purge cache of lazy variable (it’s only accessed once in this puzzle though.)
  end
  
  # [Part 2]
  # Recursively search all slabs that hard carries `self`, whether {#hard_carried_by explicitly} or implicitly.
  # The slabs `other` implicitly hard carries are the slabs hard carried
  # (explicitly or implicitly) by the *collection of* slabs that {#sits_on} `other`.
  def all_hard_carried_by
    @all_hard_carried_by ||= if hard_carried_by
      hard_carried_by.all_hard_carried_by.dup.add hard_carried_by
    else
      sits_on.map(&:all_hard_carried_by).inject(&:&) or Set.new
    end
  end
  
  
  # Check if the two rectangles *don’t* overlap if excluding the Z dimension
  def independent?(other) =
    x1 > other.x2 || x2 < other.x1 || y1 > other.y2 || y2 < other.y1
  
  def z=(z1)
    self.z2 = z2 - self.z1 + z1
    self.z1 = z1
  end
  def drop_on?(other)
    self.z = other.z2.succ unless independent? other
  end
end


STACK = []
File.foreach('input.txt')
  .map { Slab.new *_1.scan(/\d++/).map(&:to_i) }
  .sort_by!(&:z1) # I don’t think {Slab#z1} vs. {Slab#z2} matters here
  .each do|slab|
    # It’s more a Jenga than a pile, so linear is more efficient than {Array#bsearch}  
    slab.z = 0 if STACK.reverse_each.none? { slab.drop_on? _1 }
    # Ensure the {STACK} is sorted by {Slab#z2} (if only there is “sorted list”…)
    STACK.insert STACK.rindex { _1.z2 <= slab.z2 }&.succ || 0, slab
  end

STACK_BY_Z2 = STACK.group_by(&:z2)
# Fill in {#sits_on}
STACK.each do|slab|
  if (layer_below = STACK_BY_Z2[slab.z1.pred])
    slab.sits_on =
      layer_below.reject { slab.independent? _1 or slab.equal? _1 }
  end
end


puts(
  'Part 1',
  STACK.size - STACK.filter_map(&:hard_carried_by).uniq.size,
  'Part 2',
  # Totalling topples per disïntegration is equivalent to totalling disïntegrations per topple.
  STACK.sum { _1.all_hard_carried_by.size }
)
