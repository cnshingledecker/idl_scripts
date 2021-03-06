
;;
;; NOTE: First draft. Seeking feedback or use cases.
;;

;+
;
; NAME:
; PLOTBREAK
;
; PURPOSE:
;   Plot a data set with a break as per:
;   http://groups.google.com/group/comp.lang.idl-pvwave/browse_frm/thread/ce29c1ba4693c373
;   Should be a drop-in replacement for PLOT.
;
; CATEGORY:
;   Plotting
;
; CALLING SEQUENCE:
;   PLOTBREAK, X, Y
;
; INPUTS:
;   X: an array, similar to what you might pass to PLOT
;   Y: an array, similar to what you might pass to PLOT
;
; KEYWORD PARAMETERS:
;   BREAKPCT: The percentage horizontally across the plot where the
;             break should occur. Defaults to 50%
;   GAP: The break size.
;   VERTBAR: If a vertical bar should be drawn instead of "/" marks.
;   XRANGE0: The xrange of the left part
;   XRANGE1: The xrange of the right part
;
;   Etc... more complete documentation to come as code matures.
;
; EXAMPLE:
;   For now see testing code at bottom.
;
; MODIFICATION HISTORY:
;   Written by: Ken Mankoff, 2010-04-03.
;
;-

pro plotbreak, x,y, $
  breakpct=breakpct, $
  gap=gap, $
  vertbar=vertbar, $
  yrange0=yrange0, yrange1=yrange1, $
  title=title, xtitle=xtitle, $
  position=position, $
  _EXTRA_0=e0, _EXTRA_1=e1, $
  _EXTRA=e

  if not keyword_set(position) then position=[0.9,0.9,0.1,0.1]
  if not keyword_set(breakpct) then breakpct=50
  breakloc = (position[2]-position[0]) * (breakpct/100.)+position[0]
  if n_elements(gap) eq 0 then gap = 0.01 ;kdm_isdefined, gap, default=0.01

  if not keyword_set(yrange0) then yrange0=[0,max(y)/2.]
  if not keyword_set(yrange1) then yrange1=[max(y)/2.,max(y)]

  pos0 = [breakloc-gap,position[3],position[0],position[1]]
  pos1 = [position[2],position[3],breakloc+gap,position[1]]
  PRINT, 'pos=',pos0,pos1

  xrange = minmax(x)
  xrange = xrange + [-0.1,0.1]*(xrange[1]-xrange[0])

  plot, x, y, $
    position=pos0, $
    yrange=yrange0, $
    /xst, $
    yst=9, $
    xrange=xrange, $
    _EXTRA=e0

  if keyword_set(vertbar) then begin
    plots, [breakloc,breakloc], [pos0[1],pos0[3]], $
      /norm, color=254, linestyle=2, _EXTRA=e
  endif

  if not keyword_set( slashScaleV ) then slashScaleV = 2.5
  if not keyword_set( slashScaleH ) then slashScaleH = 0.5
  ;; bottom left
  slashL = convert_coord( pos0[2]-gap*slashScaleH, $
    pos0[1]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH, $
    pos0[1]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]
  ;; bottom right
  slashL = convert_coord( pos0[2]-gap*slashScaleH+(2*gap), $
    pos0[1]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH+(2*gap), $
    pos0[1]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]
  ;; top left
  slashL = convert_coord( pos0[2]-gap*slashScaleH, $
    pos0[3]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH, $
    pos0[3]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]
  ;; top right
  slashL = convert_coord( pos0[2]-gap*slashScaleH+(2*gap), $
    pos0[3]-gap*slashScaleV, /norm, /to_data )
  slashR = convert_coord( pos0[2]+gap*slashScaleH+(2*gap), $
    pos0[3]+gap*slashScaleV, /norm, /to_data )
  plots, [slashL[0],slashR[0]], [slashL[1],slashR[1]]


  plot, x,y, $
    /NOERASE, $
    /yst, $
    position=pos1, $
    yrange=yrange1, $
    xrange=xrange, $
    xst=5, $
    _EXTRA=e1

  axis, /yaxis, /yst, _EXTRA=e1

  ;; title and xtitle
  if keyword_set(title) then $
    xyouts, (position[2]+position[0])/2., $ ; X
    ;position[3] + (position[1]+position[3])*.035, $
    position[3] + 0.02, $
    charsize=1.3, $
    title, _EXTRA=e, /norm, align=0.5

  if keyword_set(xtitle) then $
    xyouts, (position[2]+position[0])/2., $ ; X
    position[1] - 0.055, $
    xtitle, _EXTRA=e, /norm, align=0.5

end

function minmax,array,subs,NAN=nan, DIMEN=dimen
  On_error,2
  compile_opt idl2
  if N_elements(DIMEN) GT 0 then begin
    amin = min(array, MAX = amax, NAN = nan, DIMEN = dimen,cmin,sub=cmax)
    if arg_present(subs) then subs = transpose([[cmin], [cmax]])
    return, transpose([[amin],[amax] ])
  endif else  begin
    amin = min( array, MAX = amax, NAN=nan, cmin, sub=cmax)
    if arg_present(subs) then subs = [cmin, cmax]
    return, [ amin, amax ]
  endelse



;; x = indgen(1000)
;; y = randomu(seed,1000)+x/250.
;; plotbreak, x, y

end

