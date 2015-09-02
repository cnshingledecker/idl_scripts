PRO barnstormer

Z = 16 ;number of electrons in target

a_p = [0.092,0.109,0.57,4.73,0.83]
J_keV = [2.50,4.19,17.6,51.7,80.7]
nu_ex = 0.5
omega_ex = [3.0,3.0,0.9,0.75,0.85]
N_fin=1000
N_init=1
Inc = .01
eV_range = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)
sigma_total = FLTARR(N_ELEMENTS(ev_range))


exs = GREEN_MCNEAL(eV_range,a_p[0],J_keV[0],nu_ex,omega_ex[0],Z,0)

plot1 =  PLOT(eV_range, YRANGE=[1E-18,2E-16], XRANGE=[1,1E3],/XLOG,  $
/YLOG,TITLE='Green-McNeal Excitation Cross-Sections for Protons in O$_2$', $
XTITLE='Proton Energy (keV)',YTITLE='Cross-Sections (cm$^2$)',/NODATA)

FOR i=0,N_ELEMENTS(a_p)-1 DO BEGIN
  extras = GREEN_MCNEAL(eV_range,a_p[i],J_keV[i],nu_ex,omega_ex[i],Z,0)
  plot2 = PLOT(eV_range, extras, LINESTYLE=i, /OVERPLOT)
  FOR counter = 0,N_ELEMENTS(eV_range)-1 DO BEGIN
    sigma_total(counter) = sigma_total(counter) + extras(counter)
  ENDFOR
ENDFOR

plot3 = PLOT(eV_range,sigma_total,/OVERPLOT,COLOR=[255,0,0])

END

FUNCTION GREEN_MCNEAL, energy, a, J, nu, omega, Z, I
  numerator = ((Z*a)^omega)*((energy - I)^nu)
  denominator = (J^(omega + nu)) + (energy^(omega + nu))
  RETURN, ((numerator)/(denominator))*1E-16
END