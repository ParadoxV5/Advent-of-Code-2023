p [[n=0,x=0],*$<.map{n+=m=_1[2..].to_i;(x+=[-m.i,-m,m,m.i][_1.ord%5]).rect}].each_cons(2).sum{|(a,b),(c,d)|a*d-b*c}.abs+n+2>>1
