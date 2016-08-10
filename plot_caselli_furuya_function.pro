FUNCTION kooij, a, b, c, T
  formula = a*((T/300)^b)*EXP(-(c/T))
  RETURN, formula
END

PRO plot_caselli_furuya_function
; === PARAMETERS ==========================================
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH
CD, '/home/cns/jenny_project/10K_0_01_OPR_single_run'
plot_name = 'rd_comparison.eps'
aff = 0 

NUM_CT = 2
ntime = 81
npoint = 1
ns = 1574

;Physical condition parameters
T = 1.0d1 ;K
xH2 = 4.99975d-1
PRINT, 'xH2=',xH2

;Rate coefficient calculations
k3f = kooij(1.7d-9,0.0d0,0.0d0,T)
PRINT, 'k3f=',k3f
k3b = kooij(8.10d-10,-8.0d-1,2.30d2,T)
PRINT, 'k3b=',k3b
khd = kooij(8.10d-10,0.0d0,0.0d0,T)
PRINT, 'khd=',khd
k2  = kooij(5.37d-10,0.0d0,0.0d0,T)
PRINT, 'k2=',k2
kh2de = kooij(1.20d-8,-5.0d-1,0.0d0,T)
PRINT, 'kh2de=',kh2de

;Species of interest
species_tab=['HCO+','DCO+','HD','CO','E']

; === IDL/GDL CODE ========================================

device,decomposed=0
if aff eq 0 then begin
  set_plot,'ps'
  device, filename=plot_name,scale_factor=2,/landscape,/COLOR
endif

nsp=size(species_tab,/N_ELEMENTS)

close,1
openr,1,'network.d'
aa = ' '
spec = strarr(ns)
for i=0,ns-1 do begin
  readf,1,format='(a12)',aa
  spec(i)=strcompress(aa, /remove_all)
endfor
close,1

ab_select_1 = fltarr(ntime,npoint)
ab_select_2 = fltarr(ntime,npoint)
ab_select_3 = fltarr(ntime,npoint)

;Generate arrays for species data
hco_plus_abundance = fltarr(ntime)
dco_plus_abundance = fltarr(ntime)
hd_abundance       = fltarr(ntime)
co_abundance       = fltarr(ntime)
e_abundance        = fltarr(ntime)
e_analytic         = fltarr(ntime)
rd_rel_abundance   = fltarr(ntime)

time = 0.
time_all = fltarr(ntime)
temp = fltarr(npoint)
dens = fltarr(npoint)
tau = fltarr(npoint)
ab = fltarr(ns,npoint)
ab_select = fltarr(ntime,npoint)

for s=0,nsp-1 do begin
  species = species_tab[s]
  index = where(spec eq species)
  IF index EQ -1 THEN STOP
  for i=0,ntime-1 do begin
    char = string(i+1,format='(i06)')
    char = strcompress('./output_1D.'+char, /remove_all)
    openr,1,char, /f77_unformatted
    readu,1,time
    time_all(i)=time
    readu,1,temp,dens,tau
    readu,1,ab
    ab_select(i,*) = ab(index,*)
    close,1
  endfor

  if s eq 0 then ab_select_1 = ab_select
  if s eq 1 then ab_select_2 = ab_select
  if s eq 2 then ab_select_3 = ab_select

  IF species EQ 'HCO+' THEN hco_plus_abundance = ab_select
  IF species EQ 'DCO+' THEN dco_plus_abundance = ab_select
  IF species EQ 'HD'   THEN hd_abundance       = ab_select
  IF species EQ 'CO'   THEN co_abundance       = ab_select
  IF species EQ 'E'    THEN e_abundance        = ab_select

  ;plot2 = plot( time_all/3.15e7,ab_select(*,0), $
  ;       linestyle=0,color=color_tab[species_color[s]], /OVERPLOT)
  ;leg = LEGEND(TARGET=[plot2], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)
  ;POSITION=[70,0.0000000001+(nsp-s-1)*0.000005+0.00001*(nsp-1-s)]
endfor ;s

;plot3 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
;       linestyle=species_style[1], /OVERPLOT)

rd_rel_abundance = hco_plus_abundance/dco_plus_abundance
rd_analytic  = fltarr(ntime)
h2_abundance = fltarr(ntime)
for h = 0,ntime-1 do begin
  h2_abundance[h] = xH2
endfor

;Calculate analytic electron abundances
prefac      = rd_rel_abundance/3.0d0
numerator   = prefac*k3f*hd_abundance - k2*co_abundance - khd*hd_abundance - k3b*h2_abundance
denominator = kh2de
e_analytic  = (prefac*numerator)/denominator

;Calculate analytic Rd ratios
numerator = k2*co_abundance + kh2de*e_abundance + khd*hd_abundance + k3b*h2_abundance
denominator = k3f*hd_abundance
rd_analytic = 3.0d0*(numerator/denominator)

cgDisplay, 800,600
cgPLOT, time_all/3.15e7, $
;      e_abundance, $
;      YRANGE=[1E-8,100], $
;      YTITLE = 'x(E)', $
      rd_rel_abundance, $
      YTITLE = '[HCO+]/[DCO+]', $
      /XLOG, $
      /YLOG, $
      linestyle=0, $
      XRANGE=[1E0,1E8], $
      XTITLE = 'Time (yr)', $
      TITLE = '10K, 1E4 1/cm3, Initial OPR=0.01, 1*Std. Zeta',$
      CHARSIZE = 2.0,$
      XMARGIN =[15,10], $
      YMARGIN =[10,10]
cgOPLOT, time_all/3.5e7, $
;         e_analytic, $
         rd_analytic, $
         linestyle=1
cgLegend, linestyles=[0,1],location=[1E4,4e4],Titles=['Full Model','Analytic Expression'],/Data
PRINT, 'last e_analytic=',e_analytic[ntime-1],' e_abundance=',e_abundance[ntime-1], ' ratio=',e_analytic[ntime-1]/e_abundance[ntime-1]

;Output the data to a csv file
out_data = fltarr(ntime,3)
out_data[*,0] = time_all/3.15e7
out_data[*,1] = e_abundance
out_data[*,2] = e_analytic
WRITE_CSV, 'electron_calculations.csv',out_data[*,0],out_data[*,1],out_data[*,2],HEADER=['time','Model Abundances','Analytic Abundances']

out_data[*,1] = rd_rel_abundance
out_data[*,2] = rd_analytic
WRITE_CSV, 'rd_calculations.csv',out_data[*,0],out_data[*,1],out_data[*,2],HEADER=['time','Model Abundances','Analytic Abundances']

;Write EPS file to PDF
if aff eq 0 then begin
  device,/close
  set_plot,'x'
  spawn, 'epstopdf '+ plot_name
endif

PRINT, 'Ending script!'
CD, '/home/cns/idl_scripts'
end
