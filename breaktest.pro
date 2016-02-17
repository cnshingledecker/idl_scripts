@yplotbreak

;y = indgen(100)/100.*3*!pi
;x = sin(x)
;plotbreak, x,y, breakpct=66, yrange0=[0,3], $
;  yrange1=[4,6], title='Sine Wave'

;plotbreak, x,y, breakpct=66, xrange0=[0,3],xrange1=[4,6],gap=0.015,$
;;  title='0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15', $
;  xtitle='The X Title Goes Here'

 x = indgen(1000)
 y = randomu(seed,1000)+x/250.
 plotbreak, x, y;,yrange0=[0,2],yrange1=[4,5],gap=0.013

END