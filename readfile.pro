PRO readfile

file = 'C:\Users\Christopher\Documents\idlfiles\temp_profile.txt'
nodes = 100
time_steps = 1000
distance = .5 ; distance in m above surface


dist = (findgen(nodes)/nodes)*distance ; generate a list of distances
openr, lun, file, /get_lun
data = fltarr(nodes,time_steps)
readf, lun, data
free_lun,lun
xmax = 0.1
title = 'Carbonaceous Chondrite (NWA 5515) r=.5m d=0.5m 20deg'
SET_PLOT, 'PS'
DEVICE, FILENAME='C:\Users\Christopher\Documents\idlfiles\nwa5515.ps', /landscape

plot, (dist),data[0:nodes-1,0], xrange=[0, xmax],xtitle="Depth (m)", ytitle="Temperature (K)", title=title
FOR i = 1,time_steps-1 DO BEGIN
  oplot, (dist), data[0:nodes-1,i]
ENDFOR

DEVICE, /CLOSE_FILE



SET_PLOT, 'WIN'

plot, (dist),data[0:nodes-1,0], xtitle="Depth (m)", ytitle="Temperature (K)",xrange=[0,xmax],title= title
FOR i = 1,time_steps-1 DO BEGIN
  oplot, (dist), data[0:nodes-1,i]
ENDFOR

END