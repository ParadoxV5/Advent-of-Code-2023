class BsearchIndexer < Proc
  def self.new(array) = super {|min| array.bsearch_index { _1 > min } || array.size }
  def initialize(array) = @array = array
  singleton_class.alias_method :[], :new
  
  def range(b, e) = self.(b)...self.(e)
    # exclude `end` because the `bsearch` is find-minimum (round up) for both edges
  def [](...) = @array[range(...)]
  
  # @return {range}`(...).size` implemented in Ruby *with no negative check*
  def size(b, e) = self.(e) - self.(b)
end
