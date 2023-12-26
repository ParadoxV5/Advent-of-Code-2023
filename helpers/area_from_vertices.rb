# A quick Google search of `area of polygon from vertices` gets us [Gauss's area formula](https://en.wikipedia.org/wiki/Shoelace_formula).
# 
# * Trapezoid formula adapted for [Day 18](../18 Lavaduct Lagoon/main.rb)
# * Just the textbook formula isn’t enough since only exactly half of the trench is counted.
#   * Each edge of the polygon has ½ of the block not counted.
#   * Simply counting edges up also overcounts by ¼ for every 270° corner.
#   * Each 90° corner also has ¼ of a block not counted.
#   * In order for the polyline to loop itself, it must have turned exactly 360°.
#     This can only come from 4 more 90°s than there are 270° turns.
# 
# @param vertices x-y or y-x coordinates of the polygon’s corners
# @param additional_perimeter
#   * the vertices’ perimeter if the perimeter’s grid is to be part of the polygon’s area
#   * the negation of the perimeter if it is excluded
def area_from_vertices(vertices, additional_perimeter) =
  (
    vertices.each_cons(2)
      .sum {|(x1, y1), (x2, y2)| (x1-x2) * (y1+y2) }
      .abs + additional_perimeter
  ) / 2 + 1
