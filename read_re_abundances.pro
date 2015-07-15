PRO read_re_abundances, filename, species, ns, times, nstep, abundances, hdens, rrr, zzz
; filename is the .idl file
; species - output - list of species
; ns - output - number of species
; times - output - moments of time with output
; nstep - output - number of moments of time with output
; abundances(nstep,ns) - output - abundances
; rrr, zzz - are only important for disk chemistry, the (R,z) coordinates of the point

openr, 30, filename

title = ""
specs = ""
rates = ""
ipon = 0
Rs = 0.0d0
Zs = 0.0d0
Temp = 0.0d0
rho = 0.0d0
rhod = 0.0d0
mdmg = 0.0d0
grain = 0.0d0
AvSt = 0.0d0
AvIS = 0.0d0
G0 = 0.0d0
ZetaCR = 0.0d0
ZetaX = 0.0d0
albedo_UV = 0.0d0
tlast = 0.0d0
tfirst = 0.0d0
nfrc = 0
ns = 0
nstep = 0
nre = 0

hdens=0.0d0
aMp=1.6724D-24

readf, 30, FORMAT='(A18)', title
readf, 30, specs
readf, 30, rates
readf, 30, FORMAT='(I5)', ipon
readf, 30, FORMAT='(E9.2)', Rs
readf, 30, FORMAT='(E9.2)', Zs
readf, 30, FORMAT='(F5.0)', Temp
readf, 30, FORMAT='(E9.2)', rho

hdens = 0.7*rho/aMp
rrr = Rs
zzz = Zs

readf, 30, FORMAT='(E9.2)', rhod
readf, 30, FORMAT='(E9.2)', mdmg
readf, 30, FORMAT='(E9.2)', grain
readf, 30, FORMAT='(E9.2)', AvSt
readf, 30, FORMAT='(E9.2)', AvIS
readf, 30, FORMAT='(E9.2)', G0
readf, 30, FORMAT='(E9.2)', ZetaCR
readf, 30, FORMAT='(E9.2)', ZetaX
readf, 30, FORMAT='(E9.2)', albedo_UV
readf, 30, FORMAT='(E9.2)', tlast
readf, 30, FORMAT='(E9.2)', tfirst
readf, 30, FORMAT='(I4)', nfrc

y0 = MAKE_ARRAY(nfrc,/STRING,VALUE="")
frc = MAKE_ARRAY(nfrc,/DOUBLE,VALUE=0.0d0)

for i=0,nfrc-1 do begin
  tmpy0=""
  tmpfrc=0.0d0
  readf, 30, FORMAT='(A10,1x,D22.15)', tmpy0,tmpfrc
  y0(i)=tmpy0
  frc(i)=tmpfrc

endfor

;readf, 30, FORMAT='(A10,1x,D22.15)', y0 , frc
readf, 30, ns

s = MAKE_ARRAY(ns,/STRING,VALUE="")

readf, 30, FORMAT='(9A10)', s
s = strcompress(s,/REMOVE_ALL)
readf, 30, nstep

times = MAKE_ARRAY(nstep,/DOUBLE,VALUE=0.0d0)

readf, 30, times
readf, 30, nre

ak = MAKE_ARRAY(nre,/DOUBLE,VALUE=0.0d0)

readf, 30, FORMAT='(10D12.5)', ak

abundances = MAKE_ARRAY(nstep,ns,/DOUBLE,VALUE=0.0d0)

readf, 30, FORMAT='(10D12.5)', abundances

close, 30

species = s

END