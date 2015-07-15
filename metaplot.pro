@legend
PRO metaplot

file = "/home/cns/Desktop/metadata.txt"
runs = 50 ; The number of runs done in an execution
data = fltarr(3,runs)
openr, lun, file, /get_lun
readf, lun, data
free_lun, lun
SET_PLOT, 'PS'
DEVICE, FILENAME='/home/cns/Desktop/metadata.eps', /landscape
!X.MARGIN=[10,10]
!Y.MARGIN=[5,5]
fit= 0.0051759575*data[0,0:runs-1]^(-0.3957945266)
title = 'Penetration Depth vs. Radius'
plot, data[0,0:runs-1],fit*1000, xtitle="Radius (m)", ytitle="Penetration Depth (mm)",title=title, linestyle=0
oplot, data[0,0:runs-1], data[2,0:runs-1], LINESTYLE=1
AXIS, YAXIS=1, YRANGE=[0,50], yticklayout=1
XYOuts, 2.65,8.00,orientation=90,'% of total radius'
legend, ['(mm)','%'], linestyle = [0,1], position = [0.74,0.87], /normal
END