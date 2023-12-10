# I found the other trick up them Bachelors of Calculus’s sleeves!
# Turns out my Math IB HL course has a use here –

# For each sequence, we let `f(i)` be the `i`th term (1-indexed).
# Since this function is constant after some number of **differentiation**,
# it is a polynomial function. That is, `f(i) = a₀ + a₁i¹ + a₂i² + …`.
# For example, `10 13 16 21 30 45` means `f(2) = a₀ + a₁(2)¹ + a₂(2)² + … = 13`
# Evaluating the powers, we get `f(2) = a₀ + 2a₁ + 4a₂ + … = 13`,
# an equation of a system that we can solve with a Matrix using Linear Algebra:
# https://www.mathsisfun.com/algebra/systems-linear-equations-matrices.html
require 'matrix'

# This version is optimized for and only supports rows with __exactly__ this many entries, no more and no less.
SIZE_MAX = 21

(1..SIZE_MAX.succ).map {|i| Enumerator.produce(1) { i * _1 }.take SIZE_MAX }.then do|matrix|
  NEXT_POWERS = matrix.pop
  MATRIX = Matrix.rows(matrix, false).inverse
end

coefficients = File.foreach('input.txt').map do|line|
   MATRIX.*(Matrix.column_vector(line.split.map(&:to_r))).column(0)
end

puts(
  'Part 1', coefficients.sum { _1.dot NEXT_POWERS },
  'Part 2', coefficients.sum { _1[0] } # `PREV_POWERS = [1, 0, 0, …]`
)
