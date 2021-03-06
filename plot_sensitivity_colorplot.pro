; pro plot_time

; Plot abundance as a function of time
; To run: .r plot_time

; === PARAMETERS ==========================================
;!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

NUM_CT = 13
zetaMax = 1E-15 ;1
zetaMin = 1E-18 ;.01

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

nrep = 249;SIZE(rep, /N_ELEMENTS)
base_rep = 'both_run_'

plot_name = species_tab[0]+'_.eps'

range_time = [1e0,1e8]
range_abundance = [1e-5,0.1]
;range_abundance = [0,1e5]

out_array = fltarr(3,ntime)
out_df = fltarr(3,1)
zeta_array = fltarr(nrep)

CD, '/home/cns/jenny_project/variational_analysis/individual_curves/opr_only_densecloud/'
zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
;pure_zeta = READ_CSV('/home/cns/Dropbox/W51C/decade_6_zeta.csv',N_TABLE_HEADER=0)
; === IDL/GDL CODE ========================================

device,decomposed=0
loadct, NUM_CT, RGB_TABLE = list_colors

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


;plot1 = plot(time_all/3.15e7,ab_select(*,0), $
;/xlog,/ylog, $ ;charthick=2, $ ;charsize=1.5, $
;xtitle='time [yr]',ytitle='[HCO+]/[DCO+]', $
;xstyle=1, xrange=range_time, $
;ystyle=1, $ ;yrange=range_abundance, $
;/NODATA,FONT_NAME='Helvetica',FONT_SIZE=20, $
;DIMENSIONS=[700,700], $
;MARGIN=[0.21,0.21,0.25,0.21],$
;YTICKVALUES = [10,100,1000,10000], $
;YTICKNAME = ['$10^1$','$10^2$','$10^3$','$10^4$'], $
;TITLE='T=10 K, n!IH2!N=10!E4!N cm!E-3!N') ;, initial OPR = 0.1');,YTICKFORMAT='(g6.0)');, BACKGROUND_COLOR='light grey')

for r=1,nrep do begin

  PRINT, 'rep',r,' of',nrep
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
  out_array(2,i) = zeta_data.FIELD1[r-1]
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
;       linestyle=species_style[1], /OVERPLOT)




zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
out_array(1,*) = ab_select_1(*,0)/ab_select_2(*,0)


out_df = [[out_df],[out_array]]

  

;PRINT, zeta_data.FIELD5[r-1]
;v1 = ALOG10(zetaMax)
;v2 = ALOG10(zetaMin)
;vx = ALOG10(zeta_data.FIELD1[r-1])


;zeta_color = FIX(255*( 1-((v1-vx)/(v1-v2)))) 
;red = list_colors[zeta_color,0]
;green = list_colors[zeta_color,1]
;blue = list_colors[zeta_color,2]
;plot4 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
;       linestyle=0,thick=0,color=[red,green,blue], /OVERPLOT )

print, r
endfor ;r


;cb = COLORBAR(target=plot4, ORIENTATION=1, position=[0.91,0.1,0.94,0.7], /BORDER,$
;              RGB_TABLE=NUM_CT,RANGE=[0,255],$
;              TICKNAME=['10!E-18!N','10!E-17!N','10!E-16!N','10!E-15!N'], $
;              TICKVALUES =[0,85,170,255], $
;;              TICKNAME=['0.01','0.1','1.0'], $
;;              TICKVALUES = [0,127,255], $
;              TITLE = '$\zeta$ (s$^{-1}$)', $
;              FONT_SIZE=20, THICK= 1,FONT_NAME='Helvetica', TEXTPOS=1)



;if aff eq 0 then begin
;  device,/close
;  set_plot,'x'
;  spawn, 'epstopdf '+plot_name
;endif

write_csv,"/home/cns/Desktop/f2a.csv",out_df

PRINT, 'Ending script!'

end
