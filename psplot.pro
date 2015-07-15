PRO psplot


SET_PLOT, 'PS'
DEVICE, FILENAME='C:\Users\Christopher\Documents\energyplot.ps', /landscape
Ea = 51
E = findgen(3*Ea, start=Ea, increment=0.01)
s = 3*8-6
A = 1e14
k = A*((E-Ea)/E)^(s-1)


plot1 = plot(E,k, TITLE='Energy vs. Rate',  XTITLE='Energy (kcal/mol)',YTITLE='Rate (1/s)' ,NAME='Energy Dependent Rate')
leg = LEGEND(TARGET=[plot1],position=[0.5,0.85])
DEVICE, /CLOSE_FILE
$ lpr myplot.ps



END