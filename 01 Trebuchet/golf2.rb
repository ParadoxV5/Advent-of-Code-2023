W=%w[\d one two three four five six seven eight nine]
p$<.sum{|l|[l[r=/#{W*?|}/],l[/.*\K#{r}/]].map{W.index(_1)||_1}.join.to_i}