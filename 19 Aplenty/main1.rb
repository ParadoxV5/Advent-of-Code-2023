# Assuming there are no infinite loops.
# FIXME: Arbitrary Code Execution vulnerability

Part = Data.define(:x, :m, :a, :s) do
  def wf_A = x + m + a + s
  def wf_R = 0
end

File.open('input.txt') do|input|
  input.each_line(chomp: true) do|line|
    break if line.empty?
    workflow, *rules, default = line.split(/[{:,}]/)
    Part.module_eval [ "def wf_#{workflow}",
      *rules.each_slice(2).map {|cond, val| "return wf_#{val} if #{cond}" },
      "wf_#{default}",
    'end' ].join("\n")
  end
  
  puts input.each_line.sum { eval("Part#{_1.tr '{=}', '[:]'}").wf_in }
end
