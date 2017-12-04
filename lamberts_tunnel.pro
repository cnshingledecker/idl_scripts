; The barrier function from Lamberts and Kaestner 2017
; returns the Langmuir-Hinshelwood rate coefficient (s-1)
function lamberts_tunnel, T
  fac1 = 1.51e10*((T/300.0)^0.86)
  fac2 = exp(-1750.0*(T+180.0)/((T^2)+(180^2)))
  return, fac1*fac2
end

; The rate of hopping over the barrier
function thermal_barrier, EA, T
  return, 1.0e12*exp(-EA/T)
end

function kappa, EACT, EA, EB, T
  k1 = lamberts_tunnel(T)
  k2 = thermal_barrier(EACT,T)
  k3 = thermal_barrier(EA,T)
  k4 = thermal_barrier(EB,T)
  return, (k1+k2)/(k1+k2+k3+k4)
end

FUNCTION Exponent, axis, index, number

  ; A special case.
  IF number EQ 0 THEN RETURN, '0'

  ; Assuming multiples of 10 with format.
  ex = String(number, Format='(e8.0)')
  pt = StrPos(ex, '.')

  first = StrMid(ex, 0, pt)
  sign = StrMid(ex, pt+2, 1)
  thisExponent = StrMid(ex, pt+3)

  ; Shave off leading zero in exponent
  WHILE StrMid(thisExponent, 0, 1) EQ '0' DO thisExponent = StrMid(thisExponent, 1)

  ; Fix for sign and missing zero problem.
  IF (Long(thisExponent) EQ 0) THEN BEGIN
    sign = ''
    thisExponent = '0'
  ENDIF

  ; Make the exponent a superscript.
  IF sign EQ '-' THEN BEGIN
    RETURN, first + 'x10!U' + sign + thisExponent + '!N'
  ENDIF ELSE BEGIN
    RETURN, first + 'x10!U' + thisExponent + '!N'
  ENDELSE

END

; Calculate tunneling rate
TSTART = 10 ;K
TINCR = 0.1
NTEMPS = 10000 ; number of temperature values
TEMPAR = FINDGEN(NTEMPS,INCREMENT=TINCR,START=TSTART)
KLHVAL = lamberts_tunnel(TEMPAR)

klhplot = PLOT($
  TEMPAR, $
  KLHVAL,$
  /DEVICE,$
  DIMENSIONS=[420,400],$
  MARGIN=[80,50,25,25],$
  FONT_SIZE=20,$
  XTICKFONT_SIZE=12,$
  YTICKFONT_SIZE=11,$
  YTITLE="k(T) (sec!E-1!N)",$
  XTITLE="Temperature (K)",$
  FONT_NAME="Hershey 3",$
  THICK=2,$
  XLOG=1,$
  YLOG=1,$
  XSTYLE=2,$
  YSTYLE=2$
;  XTICKFORMAT='exponent'$
  )

klhplot.SAVE, "/home/cns/Pictures/klhplot.eps",BORDER=kj0, RESOLUTION=1000

; Calculate rate of hopping over the barrier
EACT = 1.40e3 ; K for H + HOOH -> H2O + OH

HOPVAL = thermal_barrier(EACT,TEMPAR)

hopplot = PLOT($
  TEMPAR, $
  HOPVAL,$
  /DEVICE,$
  DIMENSIONS=[420,400],$
  MARGIN=[80,50,25,25],$
  FONT_SIZE=20,$
  XTICKFONT_SIZE=12,$
  YTICKFONT_SIZE=11,$
  YTITLE="k(T) (sec!E-1!N)",$
  XTITLE="Temperature (K)",$
  FONT_NAME="Hershey 3",$
  THICK=2,$
  XLOG=1,$
  YLOG=1,$
  XSTYLE=2,$
  YSTYLE=2$
  ;  XTICKFORMAT='exponent'$
  )

hopplot.SAVE, "/home/cns/Pictures/hopplot.eps",BORDER=kj0, RESOLUTION=1000

; Calculate kappa, the reaction/diffusion prabability
EH = 230 ; K
EHOOH = 5700/2 ; K

KAPVAL = kappa(EACT,EH,EHOOH,TEMPAR)

kapplot = PLOT($
  TEMPAR, $
  KAPVAL,$
  /DEVICE,$
  DIMENSIONS=[420,400],$
  MARGIN=[100,50,25,25],$
  FONT_SIZE=20,$
  XTICKFONT_SIZE=12,$
  YTICKFONT_SIZE=11,$
  YTITLE="Kappa",$
  XTITLE="Temperature (K)",$
  FONT_NAME="Hershey 3",$
  THICK=2,$
  XLOG=1,$
  YLOG=1,$
  XSTYLE=2,$
  YSTYLE=2,$
  YTICKFORMAT='exponent'$
  )

kapplot.SAVE, "/home/cns/Pictures/kappplot.eps",BORDER=kj0, RESOLUTION=1000

PRINT, "Ending script"

END
