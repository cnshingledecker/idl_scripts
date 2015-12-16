; pro plot_time

; Plot abundance as a function of time
; To run: .r plot_time

; === PARAMETERS ==========================================
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH


redpath = '/home/cns/w51c_reduced_data/'
varied = '001_to_3_OPR'
ntime = 81
npoint = 1
ns = 1574

species_tab=['HCO+','DCO+']
species_style=[0,1]

style1 = 0
style2 = 2

output_per_decade = 10
decade = 6
time_num = decade*output_per_decade + 1 
time_num = 61
PRINT, time_num

nrep = 499;SIZE(rep, /N_ELEMENTS)
base_rep = 'both_run_'
PRINT, "The number of reps is",nrep

plot_name = species_tab[0]+'_.eps'

range_time = [1e0,1e8]
range_abundance = [1e-5,0.1]
;range_abundance = [0,1e5]

out_array = fltarr(nrep+1,ntime)
zeta_array = fltarr(nrep)


zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
pure_zeta = READ_CSV('/home/cns/Dropbox/W51C/decade_6_zeta.csv',N_TABLE_HEADER=0)

;print, zeta_data.FIELD2

; === IDL/GDL CODE ========================================

device,decomposed=0
loadct,0

plot_name = 'plot_abundance_vs_zeta_random_log_increment_zeta_and_OPR_decade_6.eps'
print,' eps file : ',plot_name
read,'eps (0) or screen (1)',aff
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

time = 0.
time_all = fltarr(ntime)
temp = fltarr(npoint)
dens = fltarr(npoint)
tau = fltarr(npoint)
ab = fltarr(ns,npoint)
ab_select = fltarr(ntime,npoint)


;plot1 = plot(time_all/3.15e7,ab_select(*,0), $
;/xlog,/ylog, $ ;charthick=2, $ ;charsize=1.5, $
;xtitle='time [yr]',ytitle='abundance ratio', $
;xstyle=1, xrange=range_time, $
;ystyle=1, $ ;yrange=range_abundance, $
;/NODATA,FONT_NAME='Hershey 3')


for r=1,nrep do begin
;PRINT, r
rep =   base_rep + STRTRIM(r-1,1)

for s=0,nsp-1 do begin

species = species_tab[s]
index = where(spec eq species)
;PRINT, index
IF index EQ -1 THEN STOP
for i=0,ntime-1 do begin
  char = string(i+1,format='(i06)')
  char = strcompress('/home/cns/random_both_analysis/'+rep+'/output_1D.'+char, /remove_all)
  openr,1,char, /f77_unformatted
  readu,1,time
  time_all(i)=time
  out_array(0,i) = time/3.15e7
  readu,1,temp,dens,tau
  readu,1,ab
  ab_select(i,*) = ab(index,*)
  close,1
endfor

if s eq 0 then ab_select_1 = ab_select
if s eq 1 then ab_select_2 = ab_select
if s eq 2 then ab_select_3 = ab_select



;print,'    ','time [yr] abundance '+species_tab[s]+' [/nH] '+color_tab_name[species_color[s]]
;for i=0,ntime-1 do print,time_all(i)/3.15e7,ab_select(i,0)

;plot2 = plot( time_all/3.15e7,ab_select(*,0), $
;       linestyle=0,color=color_tab[species_color[s]], /OVERPLOT)

;leg = LEGEND(TARGET=[plot2], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=,/RELATIVE)

;leg = LEGEND(TARGET=[plot2], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)

;POSITION=[70,0.0000000001+(nsp-s-1)*0.000005+0.00001*(nsp-1-s)]
endfor ;s

;plot3 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
;       linestyle=species_style[1], color=color_tab[species_color[1]], /OVERPLOT)

;print, ab_select_1(*,0)/ab_select_2(*,0)

zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
out_array(r,*) = ab_select_1(*,0)/ab_select_2(*,0)
;plot4 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
;       linestyle=0,thick=0, /OVERPLOT )

;leg_name = species_tab[0] + '/' + species_tab[1]

;leg = LEGEND(TARGET=[plot3], POSITION=[0.2,0.8+s*0.1],/AUTO_TEXT_COLOR, LABEL=leg_name, FONT_NAME='Hershey 3', /RELATIVE)

;leg_name2 = species_tab[1] + '/' + species_tab[0]

;leg = LEGEND(TARGET=[plot4], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)

endfor ;r


cgplot, zeta_data.FIELD5[0:nrep-1],zeta_array, $ ;
  /xlog,/ylog, $ ;charsize=1.5, $
  xtitle='$\zeta$ x 10$\up17$ s$\up-1$',ytitle='['+species_tab[0]+']/['+species_tab[1] + ']', $
  xstyle=1,$ 
  ystyle=1, $
  TITLE='W51C at 10$\up6$ yr (T=24K & initial OPR=0.1)', PSYM=2, FONT=-1,CHARSIZE=1.5, YRANGE=[5,2E4], /NODATA

;Add observational constraint regions
xobs1 = [3E-17,1E-16,1E-16,3E-17]
yobs1 = [2E1,2E1,4E1,4E1]

xobs2 = [7E-16,2E-15,2E-15,7E-16]
yobs2 = [2E2,2E2,1E3,1E3]

polyfill, xobs1,yobs1, COLOR=175
polyfill, xobs2,yobs2, COLOR=175

oplot, zeta_data.FIELD5[0:nrep-1],zeta_array,PSYM='2', COLOR=0,SYMSIZE=0.4
tvlct, 255,0,0,125
oplot, pure_zeta.FIELD1,pure_zeta.FIELD2,PSYM='2', COLOR=50,SYMSIZE=0.4

;c = CONTOUR(zeta_array ,1E17*zeta_data.FIELD2[0:nrep-1],zeta_data.FIELD1[0:nrep-1], /FILL,/XLOG,/YLOG,YRANGE=[0.001,3],RGB_TABLE=22)
;cb = COLORBAR(position=[0.15,0.92,0.9,0.98],/BORDER,ORIENTATION=0)
;PRINT, pure_zeta.FIELD2

WRITE_CSV, '/home/cns/random_both_analysis/abundances.csv',out_array
outname = redpath + STRTRIM(string(time_num),1) + '_time_' + varied + '.csv'
PRINT, outname
WRITE_CSV, outname, zeta_data.FIELD5[0:nrep-1],zeta_array

if aff eq 0 then begin
  device,/close
  set_plot,'x'
  spawn, 'epstopdf '+plot_name
endif

;Make a 2d array containing the zeta and abundance ratio information
pure = MAKE_ARRAY(2,nrep)
pure[0,*] = pure_zeta.FIELD1
pure[1,*] = pure_zeta.FIELD2
;Print, pure 

; Sort the 2d array based on the values of the first column
sortIndex = Sort( pure[0,*] )
FOR j=0,1 DO pure[j, *] = pure[j, sortIndex]
;Print, "And the sorted data is:"
;Print, pure


;Now do the same for the both data
danger = MAKE_ARRAY(2,nrep)
danger[0,*] = zeta_data.FIELD5[0:nrep-1]
danger[1,*] = zeta_array
sortIndex = Sort( danger[0,*] )
FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]

;Now truncate the 2d array at a point in zeta corresponding to the transition
;from multiply to single valued.
zetacutoff = 1E-16
cutind = 0
FOR j=0,nrep-1 DO BEGIN
  IF ( pure[0,j] GE zetacutoff ) THEN BEGIN
    PRINT, "********************"
    PRINT, pure[0,j]
    PRINT, "The zeta value",pure[0,j]," is greater than the cutoff"
    cutind = j
    PRINT, "The cutind is: ",cutind
    BREAK
  ENDIF
ENDFOR


PRINT, "This is just to determine if the damn thing is working"


PRINT, 'Now Calculating Pearson Coefficients'
ppure = CORRELATE(pure[0,0:cutind],pure[1,0:cutind])
pdanger = CORRELATE(danger[0,0:cutind],danger[1,0:cutind])

diffval = 100*(ppure-pdanger)/ppure
PRINT, 'The pure coefficient is: ',ppure
PRINT, 'The both coefficient is: ',pdanger
PRINT, 'The difference between the two is: ', diffval,'%'

PRINT, 'Ending script!'

end
