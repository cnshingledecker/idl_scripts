PRO bb8

z1 = 1
z2 = 8
m1 = 1
m2 = 16
N_fin=1E5
N_init=0
Inc = 1
ion_range = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)
sigmas = FLTARR(N_ELEMENTS(ion_range))
Ss = FLTARR(N_ELEMENTS(ion_range))

g_fac = gamma_factor(m1,m2)
eps_vec = reduced_energy(z1,z2,m1,m2,ion_range)

PRINT, 'Starting cross-section calculation'
n = 0
FOR n=0,N_ELEMENTS(ion_range)-1 DO BEGIN
;  PRINT, 'g_fac=',g_fac
  E = ion_range[n]
;  PRINT, 'E=',E
  ep_fac = reduced_energy(z1,z2,m1,m2,E)
;  PRINT, 'ep_fac=',ep_fac
  Sn = ziegler_stopping(ep_fac,z1,z2,m1,m2)
  Ss[n] = Sn
;  PRINT, 'Sn=',Sn
  sigmas[n] = johnson_sigma(E,Sn,g_fac)
;  PRINT, 'for n=',n,' sigma=',sigmas[n]
ENDFOR
PRINT, 'Ending cross-section loop'

plot1 =  PLOT(eps_vec,/XLOG, $ ;XRANGE=[1E-2,1E4],YRANGE=[1E-16,1E-13],$
  /YLOG,TITLE='Johnson (1990) Elastic Cross-Sections for Protons in O$_2$', $
  XTITLE='Proton Energy (keV)',YTITLE='Cross-Sections (cm$^2$)',/NODATA)
  
plot2 = PLOT(eps_vec,Ss,/OVERPLOT)

END

FUNCTION reduced_energy, z1,z2,m1,m2,E
  numerator = 32.53*m2*E
  d_fac1 = z1*z2
  d_fac2 = m1 + m2
  d_fac3 = (z1^0.23) + (z2^0.23)
  denominator = d_fac1*d_fac2*d_fac3
  RETURN, numerator/denominator
END

FUNCTION gamma_factor, m1,m2
  numerator = 4*m1*m2*1.0
  denominator = 1.0*(m1 + m2)^2
  RETURN, numerator/denominator
END

FUNCTION ziegler_stopping, epsilon,z1,z2,m1,m2
  IF ( epsilon LE 30 ) THEN BEGIN
    numerator = ALOG(1 + (1.1383*epsilon))
    d_fac1 = epsilon
    d_fac2 = 0.01321*epsilon^(0.21226)
    d_fac3 = 0.19593*epsilon^(0.5)
    denominator = 2*(d_fac1 + d_fac2 + d_fac3)
  ENDIF ELSE BEGIN
    numerator = ALOG(epsilon)
    denominator = 2*epsilon
  ENDELSE
;  RETURN, numerator/denominator
  sn_reduced = numerator/denominator
  prefac_num = (8.462E-15)*z1*z2*m1
  prefac_den = (m1+m2)*((z1^(0.23))+(z2^(0.23)))
  prefac = prefac_num/prefac_den
  RETURN, prefac*sn_reduced
END

FUNCTION johnson_sigma, energy,stopping,gamma
  numerator = 2*stopping
  denominator = gamma*energy
  RETURN, numerator/denominator
END
    