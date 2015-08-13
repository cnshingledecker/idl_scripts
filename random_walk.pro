PRO random_walk

!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

infile = 'transport_track.csv'
track_data = READ_CSV(infile, N_TABLE_HEADER=0)

; Create some data.

x = track_data.FIELD1
y = track_data.FIELD2
z = track_data.FIELD3

print, x

range = [450,550]

plot1 = PLOT3D(x, y, z, $
;  XRANGE=range, YRANGE=[500,510], $
;  ZRANGE=range,$
  AXIS_STYLE=2, MARGIN=[0.2, 0.3, 0.1, 0], $
  XMINOR=0, YMINOR=0, ZMINOR=0, $
  DEPTH_CUE=[0, 2], /PERSPECTIVE, $
  XY_SHADOW=1, YZ_SHADOW=1, XZ_SHADOW=1, $
  XTITLE='x', YTITLE='y')



; Hide the three axes in the front.
; Get the array of axes and hide
; them individually.

;ax = p.AXES
;ax[2].HIDE = 1
;ax[6].HIDE = 1
;ax[7].HIDE = 1

PRINT, 'Ending script'

END
