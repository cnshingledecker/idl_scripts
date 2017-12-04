; The Spitzer & Tomasko 1968 cosmic ray energy distribution
FUNCTION spitzer_tomasko, E
  fac1 = 0.90/((0.85 + E)^2.6)
  fac2 = 1.0/(1.0 + (0.01/E))
  RETURN, fac1*fac2 ; Result has units of particles/(cm2 ster sec GeV/nucleon)
END

; The ElKomoss & Magee secondary electron energy distribution
FUNCTION elkomoss_magee, E
  COMMON sysvrs, EION, EEXC
  fac1 = 1.0/((1.0+(E/EION))^3)
  fac2 = ((1.0+(EEXC/EION))^2)/(EEXC*(1.0+(EEXC/(2*EION))))
  RETURN, fac1*fac2
END

; The numerator function in calculating the average secondary electron energy
FUNCTION se_num, E
  RETURN, E*elkomoss_magee(E)
END


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

; ----- $MAIN$ -----
; This is a program to calculate the fluxes and energy ranges of cosmic rays and secondary electrons
COMMON sysvrs, EION, EEXC
EION = 12.62 ;eV
EEXC = 11.12 ;eV

; Step 1: Calculate the cosmic ray energy distribution and integrated flux
estart = 3.0E-4 ; The starting cosmic ray energy in GeV
estop = 1.0E2 ; The final cosmic ray energy in GeV
ncr = 100000 ; The number of elements in the energy array
crinc = (estop-estart)/FLOAT(ncr) ; The increment to use in making the array

crrang = FINDGEN(ncr,INCREMENT=crinc,START=estart)
;crflux = QROMB('spitzer_tomasko',estart,estop)
crflux = QROMO('spitzer_tomasko',estart,/MIDEXP)
crflux = 4*!PI*crflux
PRINT, "The cosmic ray flux is",crflux," or maybe",1.86*crflux

yvals = spitzer_tomasko(crrang)

crplot = PLOT($
  crrang, $
  yvals,$
  /DEVICE,$
  DIMENSIONS=[420,400],$  
  MARGIN=[80,50,25,25],$
  FONT_SIZE=20,$
  XTICKFONT_SIZE=12,$
  YTICKFONT_SIZE=11,$  
  YTITLE="j(E) (Particles cm!E-2!N ster!E-1!N sec!E-1!N (GeV/nucleon)!E-1!N)",$
  XTITLE="Energy (GeV/nucleon)",$
  FONT_NAME="Hershey 3",$
  THICK=2,$
  XLOG=1,$
  YLOG=1,$
  XSTYLE=2,$
  YSTYLE=2,$
  XTICKFORMAT='exponent'$
  )

crplot.SAVE, "/home/cns/Pictures/theory_paper/f1.eps",BORDER=kj0, RESOLUTION=1000

; Step 2: Calculate the secondary electron energy distribution
sestrt = 0.0 ; The lowest SE energy in eV
sefnal = EEXC ; The largest SE energy in eV
nse = 100000 ; The number of elements in the SE electron energy array
seinc = (sefnal - sestrt)/FLOAT(nse) ; The increment to use in making the array

serang = FINDGEN(nse,INCREMENT=seinc,START=sestrt)
sedist = elkomoss_magee(serang)
semean = QROMB('se_num',sestrt,sefnal)/QROMB('elkomoss_magee',sestrt,sefnal)
PRINT, "The mean secondary electron energy is",semean," eV"

sevals = elkomoss_magee(serang)

seplot = PLOT($
  serang,$
  sevals,$
  /DEVICE,$
  DIMENSIONS=[420,400],$  
  MARGIN=[100,50,25,25],$
  FONT_SIZE=20,$
  XTICKFONT_SIZE=14,$
  YTICKFONT_SIZE=14,$  
  FONT_NAME="Hershey 3",$
  THICK=2,$  
  YTITLE="f($\epsilon$) (electrons eV!E-1!N)",$
  XTITLE="$\epsilon$ (eV)",$
  XSTYLE=2,$
  YSTYLE=2$
  )
  
seplot.SAVE, "/home/cns/Pictures/theory_paper/f3.eps",BORDER=0, RESOLUTION=1000

; Step 3: Calculate the mean electronic stopping cross section
rhocm3 = 3.0E22 ;water molecules*cm-3
stop_se_file = "/home/cns/Dropbox/Apps/ShareLaTeX/theory_paper_v2.0/stopping_powers.wsv"
nrows = FILE_LINES(stop_se_file)  ; An integer variable
OPENR, lun, stop_se_file, /GET_LUN
junk = "" ; A string variable


erange = FLTARR(nrows-1)
sestop = FLTARR(nrows-1)
data = FLTARR(2,nrows-1)
READF, lun, data
FREE_LUN, lun

erange = REFORM(data(0,*))*(1.0/1.0E3)
sestop = REFORM(data(1,*))
sestop = sestop*1.0E6*(1.0/rhocm3)
meanle = TOTAL(sestop*spitzer_tomasko(erange))/TOTAL(spitzer_tomasko(erange))
PRINT, "The mean stopping power is", meanle

leplot = PLOT($
  erange, $
  sestop,$
  /DEVICE,$
  DIMENSIONS=[420,400],$  
  MARGIN=[100,50,25,25],$
  FONT_SIZE=20,$
  XTICKFONT_SIZE=14,$
  YTICKFONT_SIZE=14,$  
  YTITLE="S$_e$(E) (cm$^2$ eV)",$
  XTITLE="Energy (GeV)",$
  FONT_NAME="Hershey 3",$
  FONT_STYLE=1,$
  THICK=2,$
  XLOG=1,$
  YLOG=1,$
  XSTYLE=2,$
  YSTYLE=2,$
  XTICKFORMAT='exponent'$  
  )

leplot.SAVE, "/home/cns/Pictures/theory_paper/f2.eps",BORDER=0, RESOLUTION=1000

   
PRINT, "Ending script"

END
