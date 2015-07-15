pro hw5

pi = 3.14159
l = findgen(40000, start=-20,increment=0.001)

f = (cos(pi*l)/(1-4*l^2))^2
db = 10*ALOG10(f)

plot = plot(l,db, xtitle='l',ytitle='P(l)')

end