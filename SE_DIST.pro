PRO SE_DIST
E = 1000 ;eV
I = 12.1 ;eV
A = 0.0289*1E-16 ;cm^2/eV
G = 19.2 ;eV
T0 = 0.938 ;eV
mass_ratio = 5.44617*10^(-4)
Tmax = 0.5*(E-I) ;4*mass_ratio*E
N_fin=600
N_init=1
Inc = .01
eV_range = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)

plot1 =  PLOT(eV_range,  XRANGE=[N_init,N_fin],/XLOG,  $
  /YLOG,TITLE='Green-Sawada Cumulative Secondary Electron Distribution for Protons in O$_2$', $
  XTITLE='Secondary Electron Energy, T (eV)',YTITLE='I(E,T) (cm$^2$)',/NODATA)

ivals = I_ET(eV_range,A,G,Tmax,T0)
plot2 = PLOT(eV_range,ivals/1E-18,/OVERPLOT)

lossval = LOSS(A,G,Tmax,T0)
imin = I_ET(0,A,G,Tmax,T0)
PRINT, lossval/imin


END

FUNCTION I_ET, energy, a, gamma, tmax, t0
  comp1 = ATAN((tmax-t0)/gamma)
  comp2 = ATAN((energy-t0)/gamma)
  RETURN, a*gamma*(comp1 - comp2)
END 

FUNCTION LOSS, a,gamma,tmax,t0
  numerator = (tmax - t0)^2 + gamma^2
  denominator = t0^2 + gamma^2
  comp1 = 0.5*ATAN(numerator/denominator)
  comp2 = (t0/gamma)*ATAN((tmax-t0)/gamma)
  comp3 = (t0/gamma)*ATAN(t0/gamma)
  prefactor = a*gamma^2
  RETURN, prefactor*(comp1 + comp2 + comp3)
END