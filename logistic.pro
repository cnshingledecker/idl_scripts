PRO logistic_fit


L = 4.0
k = 1.0
x0 = 1.0E13

x = FINDGEN(1E16)
y = L/(1 + exp(-1*k*(x-x0)))

;PLOT, x,y, /XLOG

PRINT, 'Exiting Script'

END
