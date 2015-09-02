PRO aurora2

Z=18
I_i = [12.1,16.1,16.9,18.2,20.0,23.0,37.0]
K   = [0.475,1.129,1.129,1.010,0.653,0.950,0.594]
K_B = 0.0
J   = 3.760
J_B = 0.0
J_C = 0.0
Gamma_S = 18.5
Gamma_B = [12.10,16.10,16.90,18.20,20.30,23.00,37.00]
T_S     = 1.860
T_A     = 1000.0
T_B     = [24.20,32.20,33.80,36.40,40.60,46.00,74.00]

N_fin=1E3
N_init=1
Inc = 1
ion_range = FINDGEN((N_fin-N_init+1*Inc)/Inc,START=N_init,INCREMENT=Inc)

plot1 =  PLOT(ion_range,/XLOG,XRANGE=[1,1E3],YRANGE=[1E-18,1E-15], $
  /YLOG,TITLE='Ionization Cross-Sections for Protons in O$_2$', $
  XTITLE='Proton Energy (keV)',YTITLE='Cross-Sections (cm$^2$)',/NODATA)


END

FUNCTION A_E, energy, k, k_b, j, j_b, j_c
  factor1 = k/energy + k_b
  factor2 = energy/j + j_b + j_c/energy
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