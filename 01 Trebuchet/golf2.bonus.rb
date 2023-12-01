W='_0one1two2three3four4five5six6seven7eight8nine9'.split /(\d)/
p$<.sum{_1.rindex r=/#{W*?|}/;W.index($&)/2+W.index(_1[r])/2*10}