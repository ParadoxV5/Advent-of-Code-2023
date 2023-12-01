puts( File.foreach('input.txt').sum do|line|
  line[/\d/].to_i * 10 + line[line.rindex(/\d/)].to_i
end )
