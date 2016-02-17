; Set color display mode to Decomposed Color
DEVICE, DECOMPOSED = 1
; Define variables:
@plot01
; Draw axes, no data, set the range:
PLOT, YEAR, CHINOOK, YRANGE = [MIN(SOCKEYE), MAX(CHINOOK)], $
  /NODATA, TITLE='Sockeye and Chinook Populations', $
  XTITLE='Year', YTITLE='Fish (thousands)'
 
OPLOT, YEAR, CHINOOK, LINESTYLE=0
OPLOT, YEAR, SOCKEYE, LINESTYLE=1
; Make a vector of x values for the polygon by duplicating
; the first and last points:
PXVAL = [YEAR[0], YEAR, YEAR[N1]]
; Get y value along bottom x-axis:
MINVAL = !Y.CRANGE[0]
; Make a polygon by extending the edges down to the x-axis:
POLYFILL, PXVAL, [SOCKEYE, CHINOOK,SOCKEYE], $
  COL = 0.75 * !D.N_COLORS
; Same with second polygon.
;POLYFILL, PXVAL, [MINVAL, SOCKEYE, MINVAL], $
;  COL = 0.50 * !D.N_COLORS
; Label the polygons:
XYOUTS, 1968, 430, 'SOCKEYE', SIZE=2
XYOUTS, 1968, 490, 'CHINOOK', SIZE=2

END