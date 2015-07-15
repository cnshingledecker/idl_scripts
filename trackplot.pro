PRO trackplot
file = "/home/cns/Dropbox/LEE_Sim/LOSALAMOS/plot_track.txt"
lines = 110284 ; The number of lines in the file
data = fltarr(2,lines)
openr, lun, file, /get_lun
readf, lun, data
free_lun, lun
x = data(1,*)*1E6
y = [] 
j = []
k = []


FOR i=0,lines-1 DO BEGIN
  IF ( data(0,i) eq 1.0 ) THEN BEGIN
    y = [y,data(1,i)]
  ENDIF

  IF ( data(0,i) eq 2.0 ) THEN BEGIN
    j = [j,data(1,i)]
  ENDIF

  IF ( data(0,i) eq 3.0 ) THEN BEGIN
    k = [k,data(1,i)]
  ENDIF

ENDFOR

SET_PLOT, 'PS'
DEVICE, FILENAME="/home/cns/Dropbox/LEE_Sim/LOSALAMOS/trackplot.eps"
!p.multi = [1,1,2,0,0]

PLOT, x,y, psym=2, SymSize=0.5,yrange=[-0.5,0.5], yticklen=0.0001,xrange=[0,0.008], xtitle='Depth (microns)',ytitle='Track deviation (nm)'
OPLOT, y, psym=2

PRINT, 'The number of ionizations is:', SIZE(y, /N_ELEMENTS) 
PRINT, 'The number of excitations is:', SIZE(j, /N_ELEMENTS) 
PRINT, 'The number of elastic collisions is:', SIZE(k, /N_ELEMENTS) 

END