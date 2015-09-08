PRO aurora2

Z       =     18
K_B     =    0.0
J       =  3.760
J_B     =    0.0
J_C     =    0.0
Gamma_S =   18.5
T_S     =  1.860
T_A     = 1000.0
N_fin   =    1E5
N_init  =     100
Inc     =      1
I_i     =        [12.1,16.1,16.9,18.2,20.0,23.0,37.0]
K       = [0.475,1.129,1.129,1.010,0.653,0.950,0.594]
T_B     = [24.20,32.20,33.80,36.40,40.60,46.00,74.00]
Gamma_B = [12.10,16.10,16.90,18.20,20.30,23.00,37.00]

energy = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)
sigma_total = FLTARR(N_ELEMENTS(energy))

plot1 =  PLOT(energy,/XLOG, XRANGE=[N_init,N_fin], YRANGE=[0,20],$
  /YLOG,TITLE='Green-Sawada Ionization Cross-Sections for Protons in O$_2$', $
  XTITLE='Proton Energy (eV)',YTITLE='Cross-Sections (cm$^2$)',/NODATA)
  

mass_ratio = 5.44617E-4
a_fac = A_E(energy, K[0],K_B,J,J_B,J_C)
gamma_fac = GAMMA_E(energy,Gamma_S,Gamma_B[0])
t_0_fac = T_O(energy,T_A,T_B[0],T_S)
t_max_fac = T_MAX(energy,12.1)
sigma_ion = GREEN_SAWADA(a_fac,gamma_fac,t_max_fac,t_0_fac)
i_fac = I_ET(0,a_fac,gamma_fac,t_max_fac,t_0_fac)
loss_fac = LOSS(a_fac,gamma_fac,t_max_fac,t_0_fac)
t_bar = loss_fac/i_Fac
plot2 = PLOT(energy,t_bar,LINESTYLE=n,/OVERPLOT)


  
;FOR n = 0,6 DO BEGIN
;  a_fac = A_E(energy, K[n],K_B,J,J_B,J_C)
;  gamma_fac = GAMMA_E(energy,Gamma_S,Gamma_B[n])
;  t_0_fac = T_O(energy,T_A,T_B[n],T_S)
;  t_max_fac = T_MAX(energy,I_i[n])
;  sigma_ion = GREEN_SAWADA(a_fac,gamma_fac,t_max_fac,t_0_fac)
;  plot2 = PLOT(energy,sigma_ion,LINESTYLE=n,/OVERPLOT)
;  FOR counter = 0,N_ELEMENTS(energy)-1 DO BEGIN
;    sigma_total(counter) = sigma_total(counter) + sigma_ion(counter)
;  ENDFOR
;ENDFOR
;
;plot3 = PLOT(energy,sigma_total,COLOR=[255,0,0],/OVERPLOT)



N_fin   =    500
N_init  =      1
Inc     =    0.1
tvals = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)





END

FUNCTION A_E, energy, k, k_b, j, j_b, j_c
  factor1 = (k/energy + k_b) ;*1E-16
  factor2 = energy/j ;+ j_b + j_c/energy
  RETURN, factor1*ALOG(factor2)
END 

FUNCTION GAMMA_E, energy, gamma_s, gamma_b
  numerator = gamma_s*energy
  denominator = energy + gamma_b
  RETURN, numerator/denominator
END

FUNCTION T_O, energy, t_a, t_b, t_s
  bracket = t_a/(energy + t_b)
  RETURN, t_s - bracket
END

FUNCTION T_MAX, energy, I
  RETURN, 0.5*(energy - I)
END

FUNCTION GREEN_SAWADA, a, gamma, t_max, t_0
  bracket = (t_max - t_0)/gamma
  paren = t_0/gamma
  insides = ATAN(bracket) + ATAN(paren)
  RETURN, a*gamma*(insides)
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