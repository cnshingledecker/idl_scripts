PRO bb8


END

FUNCTION reduced_energy, z1,z2,m1,m2,E,
  numerator = 32.53*m2*E
  d_fac1 = z1*z2
  d_fac2 = m1 + m2
  d_fac3 = (z1^0.23) + (z2^0.23)
  denominator = d_fac1*d_fac2*d_fac3
  RETURN, numerator/denominator
END

FUNCTION gamma_factor, m1,m2,
  numerator = 4*m1*m2
  denominator = (m1 + m2)^2
  RETURN, numerator/denominator
END

FUNCTION ziegler_stopping, epsilon
  IF ( epsilon LE 30 ) THEN BEGIN
    numerator = ALOG(1 + (1.1383*epsilon))
    d_fac1 = epsilon
    d_fac2 = 0.01321*epsilon^(0.21226)
    d_fac3 = 0.19593*epsilon^(0.5)
    denominator = 2(d_fac1 + d_fac2 + d_fac3)
  ENDIF ELSE BEGIN
    numerator = ALOG(epsilon)
    denominator = 2*epsilon
  ENDELSE
  RETURN, numerator/denominator
END

FUNCTION johnson_sigma, energy,stopping,gamma,
  numerator = 2*stopping
  denominator = gamma*energy
  RETURN, numerator/denominator
END
    