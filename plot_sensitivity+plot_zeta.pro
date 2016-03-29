; pro plot_time

; Plot abundance as a function of time
; To run: .r plot_time

; === PARAMETERS ==========================================
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

NUM_CT = 13
loadct, NUM_CT, RGB_TABLE = list_colors

zmax = 1E-15
zmin = 1E-18

ntime = 81
npoint = 1
ns = 1574

species_tab=['D','HCO+','DCO+']
temperature = 10

output_per_decade = 10
decade = 6
time_num = decade*output_per_decade + 1
;time_num = 61

nrep = 228;SIZE(rep, /N_ELEMENTS)
base_rep = 'both_run_'

x_range = [1e0,1e8]
y_range = [1.0E-18,1.0E-4]

;out_array = fltarr(nrep+1,ntime)
;zeta_array = fltarr(nrep)


;zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
;pure_zeta = READ_CSV('/home/cns/Dropbox/W51C/decade_6_zeta.csv',N_TABLE_HEADER=0)
;plot_name = '/home/cns/Pictures/24K_opr_vs_zeta.eps'
CD, '~/jenny_project/10K_3_OPR_single_run'

; === IDL/GDL CODE ========================================

device,decomposed=0
loadct,NUM_CT

aff = 1
if aff eq 0 then begin
  set_plot,'ps'
  device, filename=plot_name,scale_factor=1.1,/landscape,/COLOR
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

;------------------------------------------------------------------------
;-----2D PLOT------------------------------------------------------------
plot1 = plot( time_all/3.15e7, ab_select(*,0), $
  /xlog,/ylog, /zlog,$ ;charthick=2, $ ;charsize=1.5, $
  xtitle='time [yr]',ytitle= 'n!IX!N/n!IH2!N', $ ;'['+species_tab[0] + ']', $
  XRANGE=x_range, $
  /NODATA,FONT_NAME='Hershey 3',FONT_SIZE=16,$
  title='T=' + STRTRIM(STRING(FIX(temperature)),2) + ' K, n!IH2!N=10!E4!N cm!E-3!N',$
  MARGIN=[0.15,0.15,0.1,0.15], ASPECT_RATIO=0.5 )
;------------------------------------------------------------------------


;-----------------------------------------------------------------------
;----3D PLOT------------------------------------------------------------
;plot1 = plot3d( time_all/3.15e7, zeta_data.FIELD5,ab_select(*,0), $
;/xlog,/ylog, /zlog,$ ;charthick=2, $ ;charsize=1.5, $
;xtitle='time [yr]',ztitle='[HCO+]/[DCO+]',ytitle='Ionization rate (s!E-1!N)', $
;xrange=[1,9E7],yrange=[1E-18,1E-15],zrange=[1,1E5], $
;xstyle=1,$ ;xrange=range_time, $
;ystyle=1,  $
;AXIS_STYLE=1,$
;SHADOW_COLOR="red", $
;YZ_SHADOW=1, $
;ZTICKVALUES=[10,100,1000,10000,100000], $
;YTICKVALUES=[1E-18,1E-17,1E-16,1E-15], $
;;XTICKVALUES=[1E1,1E3,1E4,1E5,1E7], $
;/NODATA,FONT_NAME='Hershey 3',/PERSPECTIVE);, title='[DCO+]/[HCO+] vs. time')
;
;ax = plot1.AXES
;
;ax[0].TICKDIR = 1 ;[]'time [yr]'
;ax[1].LOCATION = [9E7,1E-18,1] ; 'Ionization rate'
;ax[1].TEXTPOS = 1
;ax[2].LOCATION = [9E7,1E-15,1]  ;'[HCO+]/[DCO+]'
;ax[2].TEXTPOS = 1
;--------------------------------------------------------------------


;for r=1,nrep do begin
;  rep =   base_rep + STRTRIM(r-1,1)
;  IF ( zeta_data.FIELD1[r-1] gt 1 or zeta_data.FIELD5[r-1] gt 1E-15 or zeta_data.FIELD5[r-1] lt 1E-18) THEN BEGIN
;    GOTO, jump1
;  ENDIF


for s=0,nsp-1 do begin

species = species_tab[s]
index = where(spec eq species)
;PRINT, 'Index=',index
IF index EQ -1 THEN STOP
for i=0,ntime-1 do begin
  char = string(i+1,format='(i06)')
;  char = strcompress( './' + rep + '/output_1D.'+char, /remove_all)
  char = strcompress( './' + '/output_1D.'+char, /remove_all)
  openr,1,char, /f77_unformatted
  readu,1,time
  time_all(i)=time
;  out_array(0,i) = time/3.15e7
  readu,1,temp,dens,tau
  readu,1,ab
  ab_select(i,*) = ab(index,*)
  close,1
endfor


if s eq 0 then ab_select_1 = ab_select
if s eq 1 then ab_select_2 = ab_select
if s eq 2 then ab_select_3 = ab_select


;-------------------------------------------------------------------------------
;-----2D PLOT-------------------------------------------------------------------
;-----Abundance-----------------------------------------------------------------
;-------------------------------------------------------------------------------
plot2 = plot( time_all/3.15e7,ab_select(*,0), $
       linestyle = s, /OVERPLOT )

;leg = LEGEND(TARGET=[plot2], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=,/RELATIVE)
; leg = LEGEND(TARGET=[plot2], POSITION=[0.87,0.2+s*0.1], LABEL=species_tab[s], $
      ; SHADOW = 0, /RELATIVE)

;POSITION=[70,0.0000000001+(nsp-s-1)*0.000005+0.00001*(nsp-1-s)]
endfor ;s

;IF ( zeta_data.FIELD1[r-1] le 1 or zeta_data.FIELD5[r-1] le 1E-15 ) THEN BEGIN
;  zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
;ENDIF
;out_array(r,*) = ab_select_1(*,0)/ab_select_2(*,0)


;-------------------------------------------------------------------------------
;-----Get Color Info------------------------------------------------------------
;-------------------------------------------------------------------------------
;PRINT, ab_select_1(*,0)/ab_select_2(*,0)
;FOR nn = 0,nrep-1 DO BEGIN
; zeta_array[nn] = zeta_data.FIELD5[r-1]
;ENDFOR

;v1 = ALOG10(zmax)
;v2 = ALOG10(zmin)
;vx = ALOG10(zeta_data.FIELD5[r-1])
;zeta_color = FIX(255*( 1-((v1-vx)/(v1-v2))))

;-------------------------------------------------------------------------
;-----2D PLOT-------------------------------------------------------------
;-----Abundance ratio-----------------------------------------------------
;-------------------------------------------------------------------------
;plot3 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0),/OVERPLOT ) ;, $
;              color=[list_colors[zeta_color,0],list_colors[zeta_color,1],list_colors[ze
;-----------------------------------------------------------------------
;----3D PLOT------------------------------------------------------------
;plot4 = plot3d( time_all/3.15e7, zeta_array,ab_select_1(*,0)/ab_select_2(*,0),$
;                SHADOW_COLOR="red", $
;                YZ_SHADOW=1, $
;               /SYM_FILLED,linestyle=0,thick=2,$
;                color=[list_colors[zeta_color,0],list_colors[zeta_color,1],list_colors[zeta_color,2]], /OVERPLOT )

;leg_name = species_tab[0] + '/' + species_tab[1]
;
;leg = LEGEND(TARGET=[plot3], POSITION=[0.2,0.8+s*0.1],/AUTO_TEXT_COLOR, LABEL=leg_name, FONT_NAME='Hershey 3', /RELATIVE)

;leg_name2 = species_tab[1] + '/' + species_tab[0]

;leg = LEGEND(TARGET=[plot4], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)
;jump1: PRINT, 'parameters out of range'
;endfor ;r

leg = LEGEND(POSITION=[0.85,0.3],FONT_SIZE=16,FONT_NAME='Hershey 3',/RELATIVE)
leg[0].label = species_tab[0]
leg[1].label = species_tab[1]
leg[2].label = species_tab[2]

plot2.yrange = [1E-18,1E-4]

;porygon = POLYGON([1E6,1E6,1E6,1E6],[1E-18,1E-18,1E-15,1E-15],[1,1E5,1E5,1],$
;                   TARGET=plot4,/DATA, FILL_COLOR='gray', FILL_TRANSPARENCY=10)
;

;zetaplot = plot(zeta_data.FIELD5[0:nrep-1]*1E17, zeta_array, $;zeta_data.FIELD5[0:nrep-1]*1E17,zeta_array, $ ;
;  /xlog,/ylog, $ ;charsize=1.5, $
;  ytitle='['+species_tab[0]+']/['+species_tab[1] + ']', $
;  xtitle = '    x 10!E17!N s!E-1!N', $
;  xstyle=1,$
;  ystyle=1, $
;  TITLE='time = 10!E6!N yr, T=24 K, n!DH2!N=10!E5!N cm!E-3!N', $
;  ;  LINESTYLE=0, THICK=2, COLOR='red', $
;  SYMBOL='Circle',SYM_FILLED=1,SYM_SIZE=0.7,COLOR='black',LINESTYLE='6', $
;  FONT_NAME='Hershey 3',FONT_SIZE=12, $
;  YRANGE=[0.001,10], XRANGE=[8E-2,200],MARGIN=[0.2,0.2,0.1,0.1])

;tvlct, 255,0,0,125
;oplot, zeta_data.FIELD5[0:nrep-1],zeta_array,PSYM='2', COLOR=125,SYMSIZE=0.4
;oplot, pure_zeta.FIELD1,pure_zeta.FIELD2,PSYM='2', COLOR=125,SYMSIZE=0.4

;c = CONTOUR(zeta_array ,1E17*zeta_data.FIELD2[0:nrep-1],zeta_data.FIELD1[0:nrep-1], /FILL,/XLOG,/YLOG,YRANGE=[0.001,3],RGB_TABLE=22)
;cb = COLORBAR(target=plot3,/BORDER,ORIENTATION=1, position=[0.91,0.1,0.94,0.7],$
;              RGB_TABLE=NUM_CT,RANGE=[0,255],$
;              TICKNAME=['10!E-18!N s!E-1!N','10!E-17!N s!E-1!N','10!E-16!N s!E-1!N','10!E-15!N s!E-1!N'], $
;              TICKVALUES =[0,85,170,255],TEXTPOS=1, $
;              FONT_SIZE=10, THICK= 0.5,FONT_NAME='Hershey 3')

;out_array = TRANSPOSE(out_array)
;WRITE_CSV, '/home/cns/random_both_analysis/abundances.csv',out_array

;aff = 0
;if aff eq 0 then begin
;;  device,/close
;;  set_plot,'x'
;  spawn, 'epstopdf '+plot_name
;endif

CD, '~/idl_scripts'
PRINT, 'Ending script!'

end
