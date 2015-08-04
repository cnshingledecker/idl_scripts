; pro plot_time

; Plot abundance as a function of time
; To run: .r plot_time

; === PARAMETERS ==========================================

ntime = 71 
npoint = 1
ns = 1574

species_tab=['DCO+','HCO+']
species_style=[0,1]

style1 = 0
style2 = 2


nrep = 50;SIZE(rep, /N_ELEMENTS)
base_rep = 'OPR_run_'
PRINT, "The number of reps is",nrep

plot_name = species_tab[0]+'_.eps'

range_time = [1e0,1e7]
range_abundance = [1e-4,1]
;range_abundance = [0,1e5]

out_array = fltarr(nrep+1,ntime)

; === IDL/GDL CODE ========================================

device,decomposed=0

print,' eps file : ',plot_name
read,'eps (0) or screen (1)',aff
if aff eq 0 then begin
  set_plot,'ps'
  device, xsize=20,ysize=15,filename=plot_name,scale_factor=1,/landscape
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


plot1 = plot(time_all/3.15e7,ab_select(*,0), $
/xlog,/ylog, $ ;charthick=2, $ ;charsize=1.5, $
xtitle='time [yr]',ytitle='abundances [/n!DH!N]', $
xstyle=1, xrange=range_time, $
ystyle=1, $ ;yrange=range_abundance, $
/NODATA,FONT_NAME='Hershey 3',TITLE=species_tab[0]+'/'+species_tab[1]+' Sensitivity Analysis' )


for r=0,nrep do begin
rep = base_rep + STRTRIM(r,1)

for s=0,nsp-1 do begin

species = species_tab[s]
index = where(spec eq species)

for i=0,ntime-1 do begin
  char = string(i+1,format='(i06)')
  char = strcompress('./'+rep+'/output_1D.'+char, /remove_all)
  openr,1,char, /f77_unformatted
  readu,1,time
  time_all(i)=time
  out_array(0,i) = time/3.15e7
  readu,1,temp,dens,tau
  readu,1,ab
  ab_select(i,*) = ab(index,*)
  out_array(r,i) = ab(index,*) 
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

plot4 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
       linestyle=0,thick=0, /OVERPLOT )

;leg_name = species_tab[0] + '/' + species_tab[1]

;leg = LEGEND(TARGET=[plot3], POSITION=[0.2,0.8+s*0.1],/AUTO_TEXT_COLOR, LABEL=leg_name, FONT_NAME='Hershey 3', /RELATIVE)

;leg_name2 = species_tab[1] + '/' + species_tab[0]

;leg = LEGEND(TARGET=[plot4], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)

endfor ;r




out_array = TRANSPOSE(out_array)
WRITE_CSV, 'abundances.csv',out_array

PRINT, 'Ending script!'

end
