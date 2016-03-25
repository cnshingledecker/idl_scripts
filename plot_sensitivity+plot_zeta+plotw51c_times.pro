; pro plot_time

; Plot abundance as a function of time
; To run: .r plot_time

; === PARAMETERS ==========================================
;!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

NUM_CT = 13
zetaMax = 1 ;1E-15 ;1
zetaMin = .01 ;1E-18 ;.01

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
decade = 7
time_num = decade*output_per_decade + 1 
;time_num = 61
;PRINT, time_num

isoreps = ['0_1_zeta_only','0_01_zeta_only','1_zeta_only','3_zeta_only']
nrep = 499;SIZE(rep, /N_ELEMENTS)
base_rep = 'both_run_'
PRINT, "The number of reps is",nrep

plot_name = species_tab[0]+'_.eps'

range_time = [1e0,1e8]
range_abundance = [1e-5,0.1]
;range_abundance = [0,1e5]

out_array = fltarr(nrep+1,ntime)
zeta_array = fltarr(nrep)

CD, '/home/cns/jenny_project/random_both_analysis'

zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
pure_zeta = READ_CSV('/home/cns/Dropbox/W51C/decade_6_zeta.csv',N_TABLE_HEADER=0)

;print, zeta_data.FIELD2

; === IDL/GDL CODE ========================================
set_plot, 'x'
device,decomposed=0
loadct, NUM_CT, RGB_TABLE = list_colors


plot_name = '/home/cns/Dropbox/W51C_paper/1E6_w51c.eps'
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
  char = strcompress(rep+'/output_1D.'+char, /remove_all)
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

endfor ;s

;plot3 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
;       linestyle=species_style[1], /OVERPLOT)


zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
out_array(r,*) = ab_select_1(*,0)/ab_select_2(*,0)

endfor ;r

PRINT, list_colors[zetaColor,*]

;Now do the same for the both data
danger = MAKE_ARRAY(2,nrep)
danger[0,*] = zeta_data.FIELD5[0:nrep-1]
danger[1,*] = zeta_array
sortIndex = Sort( danger[0,*] )
FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]

plot1 = plot(danger[0,*]*1E17,danger[1,*], $;zeta_data.FIELD5[0:nrep-1]*1E17,zeta_array, $ ;
  /xlog,/ylog, $ ;charsize=1.5, $
  ytitle='['+species_tab[0]+']/['+species_tab[1] + ']', $
  xtitle = '    x 10!E17!N s!E-1!N', $
  xstyle=1,$ 
  ystyle=1, $
  TITLE='T=24 K, n!DH2!N=10!E4!N cm!E-3!N', $
;  LINESTYLE=0, THICK=2, COLOR='red', $
  SYMBOL='Circle',SYM_FILLED=1,SYM_SIZE=0.7,COLOR='black',LINESTYLE='6', $
  FONT_NAME='Hershey 3',FONT_SIZE=12, $
  YRANGE=[8,1E4], XRANGE=[1E-1,200],MARGIN=[0.2,0.2,0.1,0.1]);, /NODATA
xname = TEXT(0.47,0.127,'f',FONT_NAME='Hershey 4')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CD, '../0_01_zeta_only'
nrep = 309;SIZE(rep, /N_ELEMENTS)

out_array = fltarr(nrep+1,ntime)
zeta_array = fltarr(nrep)
zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
nsp=size(species_tab,/N_ELEMENTS)

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

for r=1,nrep do begin
  rep =   base_rep + STRTRIM(r,1)

  for s=0,nsp-1 do begin

    species = species_tab[s]
    index = where(spec eq species)
    ;PRINT, index
    IF index EQ -1 THEN STOP
    for i=0,ntime-1 do begin
      char = string(i+1,format='(i06)')
      char = strcompress(rep+'/output_1D.'+char, /remove_all)
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
  endfor ;s

  zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
  out_array(r,*) = ab_select_1(*,0)/ab_select_2(*,0)
endfor ;r
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loadct, NUM_CT
zetaline = MAKE_ARRAY(2,nrep)
zetaline[0,*] = zeta_data.FIELD5[0:nrep-1]
zetaline[1,*] = zeta_array
sortIndex = Sort( zetaline[0,*] )
FOR j=0,1 DO zetaline[j, *] = zetaline[j, sortIndex]
plot2 = plot(zetaline[0,*]*1E17,zetaline[1,*],LINESTYLE='0', THICK=2, COLOR=[220,20,60],/OVERPLOT)

if aff eq 0 then begin
  device,/close
;  set_plot,'x'
  spawn, 'epstopdf /home/cns/Dropbox/W51C_paper/1E6_w51c.eps'
endif

PRINT, 'Ending script!'

end
