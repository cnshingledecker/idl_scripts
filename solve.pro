PRO solve
!EXCEPT=0
  z1 = 1
  z2 = 8
  a = a_fac(z1,z2)
  maxiter = 20
  tol     = 1.d-14
  x       = 5.d0 ;initial guess 

  FOR k=1,maxiter DO BEGIN
    fx = zbl(z1,z2,x,a)
    fxprime = zbl_prime(x,z1,z2,a)
    
    IF (  ABS(fx) LT tol ) THEN BREAK

    deltax = fx/fxprime

    x = x - deltax
  ENDFOR

  IF ( k GT maxiter ) THEN BEGIN

    fx = zbl(z1,z2,x,a)
    IF ( ABS(fx) LT tol ) THEN PRINT, '***Warning: Has not converged'
  ENDIF
  iters = k-1
  PRINT, x, fx
END

FUNCTION a_fac, z1, z2
  a_0 = 0.529 ;Bohr radius in Angstroms
  numerator = 0.8853*a_0
  dfac1 = z1^(2/3)
  dfac2 = z2^(2/3)
  denominator = dfac1 + dfac2
  RETURN, numerator/denominator
END 

FUNCTION ffp, m1,m2,energy,rho,a
  insides = (1 + (m1 + m2))^2
  nfac1 = 0.02*insides*(energy^2)
  nfac2 = 0.1*(energy^(1.38))
  numerator = nfac1 + nfac2
  dfac1 = 4*!CONST.PI*rho*(a^2)
  dfac2 = ALOG(1 + energy)
  denominator = dfac1*dfac2
  RETURN, numerator/denominator
END

FUNCTION lab_theta, cm_theta, m1, m2
  numerator = SIN(cm_theta)
  denominator = COS(cm_theta) + (m1/m2)
  insides = numerator/denominator
  RETURN, ATAN(insides)
END

FUNCTION energy_transfer, energy_0,m1,m2,sin_fac
  numerator = 4*energy_0*m1*m2
  denominator = (m1 + m2)^2
  prefac = numerator/denominator
  RETURN, prefa*sin_fac
END

FUNCTION b_fac, rand,rho,ffp_fac,a_fac
  numerator = -1*ALOG(rand)
  denominator = !CONST.PI*rho*ffp_fac
  p = numerator/denominator
  RETURN, p/a_fac
END

FUNCTION phi_angle, rand
  RETURN, 2*!CONST.PI*rand
END

FUNCTION red_rad, r_0, a_fac
  RETURN, r_0/a_fac
END

FUNCTION zbl, z1,z2,r,a
  ;Returns the potential, in eV/cm
  prefac = (z1*z2)/r 
  sfac1 = 0.181*EXP(-3.2*(r/a))
  sfac2 = 0.5099*EXP(-0.9423*(r/a))
  sfac3 = 0.2802*EXP(-0.4029*(r/a))
  sfac4 = 0.02817*EXP(-0.2016*(r/a))
  screening = sfac1 + sfac2 + sfac3 + sfac4
  RETURN, prefac*screening
END

FUNCTION zbl_prime,r,z1,z2,a
  a1 = 0.181
  a2 = 0.5099
  a3 = 0.2802
  a4 = 0.02817
  prefac1 = (z1*z2)/r
  qfac1 = (-3.2*a1*EXP(-3.2*(r/a)))/a
  qfac2 = (-0.9423*a2*EXP(-0.9423*(r/a)))/a
  qfac3 = (-0.4029*a3*EXP(-0.4029*(r/a)))/a
  qfac4 = (-0.2016*a4*EXP(-0.2016*(r/a)))/a
  qfac  = qfac1 + qfac2 + qfac3 + qfac4
  fac1 = prefac1*qfac
  prefac2num = z1*z2
  prefac2den = r^2
  prefac2 = prefac2num/prefac2den
  scfac1 = a1*EXP(-3.2*(r/a))
  scfac2 = a2*EXP(-0.9423*(r/a))
  scfac3 = a3*EXP(-0.4029*(r/a))
  scfac4 = a4*EXP(-0.2016*(r/a))
  screening = scfac1 + scfac2 + scfac3 + scfac4
  fac2 = prefac2*screening
  RETURN, fac1 - fac2
END
 