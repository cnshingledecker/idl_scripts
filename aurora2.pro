PRO aurora2

Z       =     18
K_B     =    0.0
J       =  3.760
J_B     =    0.0
J_C     =    0.0
Gamma_S =   18.5
T_S     =  1.860
T_A     = 1000.0
N_fin   =    1E3
N_init  =     10
Inc     =      1
I_i     =        [12.1,16.1,16.9,18.2,20.0,23.0,37.0]
K       = [0.475,1.129,1.129,1.010,0.653,0.950,0.594]
T_B     = [24.20,32.20,33.80,36.40,40.60,46.00,74.00]
Gamma_B = [12.10,16.10,16.90,18.20,20.30,23.00,37.00]

energy = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)
sigma_total = FLTARR(N_ELEMENTS(energy))

plot1 =  PLOT(energy,/XLOG,XRANGE=[10,1E3], $
  /YLOG,TITLE='Green-Sawada Ionization Cross-Sections for Protons in O$_2$', $
  XTITLE='Proton Energy (eV)',YTITLE='Cross-Sections (cm$^2$)',/NODATA)
  

;a_fac = A_E(energy, K[0],K_B,J,J_B,J_C)
;gamma_fac = GAMMA_E(energy,Gamma_S,Gamma_B[0])
;t_0_fac = T_O(energy,T_A,T_B[0],T_S)
;t_max_fac = T_MAX(energy,I_i[0])
;sigma_ion = GREEN_SAWADA(a_fac,gamma_fac,t_max_fac,t_0_fac)
;PRINT, 'eV=',energy[40],' $Gamma$ =',gamma_fac[40],' T_0 =',t_0_fac[40], ' A =',a_fac[40]
;plot2 = PLOT(energy,sigma_ion,LINESTYLE=n,/OVERPLOT)

  
FOR n = 0,6 DO BEGIN
  a_fac = A_E(energy, K[n],K_B,J,J_B,J_C)
  gamma_fac = GAMMA_E(energy,Gamma_S,Gamma_B[n])
  t_0_fac = T_O(energy,T_A,T_B[n],T_S)
  t_max_fac = T_MAX(energy,I_i[n])
  sigma_ion = GREEN_SAWADA(a_fac,gamma_fac,t_max_fac,t_0_fac)
;  PRINT, '$Gamma$ =',gamma_fac,'T_0 =',t_0_fac
;  PRINT, 'A =',a_fac
  plot2 = PLOT(energy,sigma_ion,LINESTYLE=n,/OVERPLOT)
  FOR counter = 0,N_ELEMENTS(energy)-1 DO BEGIN
    sigma_total(counter) = sigma_total(counter) + sigma_ion(counter)
  ENDFOR
ENDFOR

plot3 = PLOT(energy,sigma_total,COLOR=[255,0,0],/OVERPLOT)

PRINT, sigma_total


END

FUNCTION A_E, energy, k, k_b, j, j_b, j_c
  factor1 = (k/energy + k_b)*1E-16
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