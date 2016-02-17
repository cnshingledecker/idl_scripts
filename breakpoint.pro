data = Findgen(1000) + 1
plot, data, Position=[0.15, 0.15, 0.9, 0.35], XStyle=8, $
  YRange=[1,99], YStyle=1
plot, data, Position=[0.15, 0.35, 0.9, 0.9], XStyle=4, $
  YRange=[101,1000], /YLog, /NoErase
axis, xaxis=1, xtickformat='(A1)'

END