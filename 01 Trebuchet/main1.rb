puts( File.foreach('input.txt').sum do|line|
  line[/\d/].to_i * 10 + line[/(\d)\D*$/, 1].to_i
end )
