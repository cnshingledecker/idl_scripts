PRO logistic_fit
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH


L = 4
k =.8
x0 = 1E13

start_val = 1E10
end_val = 1E17
s = ALog10(start_val)
f = ALog10(end_val)
x = cgScaleVector(Findgen(100000),s,f)
x = 10.^x
y = ((L*x^k)/(x0^k + x^k))

p1 = Plot( x,y,/XLOG,XRANGE=[start_val,end_val] )

PRINT, 'Exiting Script'

END
