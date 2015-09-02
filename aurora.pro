PRO aurora

Z = 16 ;number of electrons in target

a_ion = [9.56,5.38,5.25,3.19,0.94,15.6,8.75]
J_ion = [45.8,127.1,170.3,142.4,140.8,56.0,57.0]
nu_ion = [0.61,1.1,1.1,1.1,1.1,1.2,1.2]
omega_ion = [1.26,0.58,0.60,0.58,0.58,0.72,0.72]
I_ion = [12.1,16.1,16.9,18.2,23.0,18.0,22.0]
N_fin=1E3
N_init=1
Inc = 1
ion_range = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)
sigma_total = FLTARR(N_ELEMENTS(ion_range))


plot1 =  PLOT(ion_range,/XLOG,XRANGE=[1,1E3],YRANGE=[1E-18,1E-15], $
  /YLOG,TITLE='Green-McNeal Ionization Cross-Sections for Protons in O$_2$', $
  XTITLE='Proton Energy (keV)',YTITLE='Cross-Sections (cm$^2$)',/NODATA)
  
;ions = GREEN_MCNEAL(ion_range,a_ion[2],J_ion[2],nu_ion[2],omega_ion[2],Z,I_ion[2])
;plot2 = PLOT(ion_range,ions, /OVERPLOT)



FOR i=0,6 DO BEGIN
  ions = GREEN_MCNEAL(ion_range,a_ion[i],J_ion[i],nu_ion[i],omega_ion[i],Z,I_ion[i])
  plot2 = PLOT(ion_range, ions, LINESTYLE=i, /OVERPLOT)
  FOR counter = 0,N_ELEMENTS(ion_range)-1 DO BEGIN
    sigma_total(counter) = sigma_total(counter) + ions(counter)
  ENDFOR
ENDFOR

plot3 = PLOT(ion_range,sigma_total,/OVERPLOT,COLOR=[255,0,0])


END

FUNCTION GREEN_MCNEAL, energy, a, J, nu, omega, Z, I
  numerator = ((Z*a)^omega)*((energy - (I/1E3))^nu)
  denominator = (J^(omega + nu)) + (energy^(omega + nu))
  RETURN, ((numerator)/(denominator))*1E-16
END

