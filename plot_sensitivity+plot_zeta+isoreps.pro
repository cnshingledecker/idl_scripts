; === PARAMETERS ==========================================
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

NUM_CT = 2
zetaMax = 1 ;1E-15 ;1
zetaMin = .01 ;1E-18 ;.01

xmin = 0.1
xmax = 100
ymax = 1E3
ymin = 0.1
obsmax = 833.33
obsmin = 625.00


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
time_num = 51
;PRINT, time_num

;isoreps = ['0_01_fixed_OPR','0_1_fixed_OPR','3_fixed_OPR']
isoreps = ['0_01_L1174_opr_fixed','0_1_L1174_opr_fixed','3_L1174_opr_fixed']
;wintitle = ['Varied','0.01','0.1','3']
;isocolor = ['red','green','blue']
isonum = SIZE(isoreps, /N_ELEMENTS)
nrep = 214;SIZE(rep, /N_ELEMENTS)
out_csv_name = "hco+_dco+_both_opr.csv"
base_rep = 'both_run_'
PRINT, "The number of reps is",nrep

;plot_name = species_tab[0]+'_.eps'
plot_name = '1'

range_time = [1e0,1e8]
range_abundance = [1e-5,0.1]
;range_abundance = [0,1e5]

out_array = fltarr(nrep+1,ntime)
zeta_array = fltarr(nrep)
out_df = fltarr(2,1)
rep_df = make_array(1,value="X")

CD, '/run/media/cns/3C87-68DE/shingledecker_et_al_2016/reduced_L1174'
;CD, 'E:\jenny_project\variational_analysis\105_dens_at_10K\'

zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)

; === IDL/GDL CODE ========================================

device,decomposed=0
loadct, NUM_CT, RGB_TABLE = list_colors

print,' eps file : ',plot_name
;read,'eps (0) or screen (1)',aff
aff = 0
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
;xtitle='time [yr]',ytitle='[HCO+]/[DCO+]', $
;xstyle=1, xrange=range_time, $
;ystyle=1, $ ;yrange=range_abundance, $
;/NODATA,FONT_NAME='Hershey 3',FONT_SIZE=16, $
;DIMENSIONS=[1000,1000], $
;MARGIN=[0.2,0.1,0.1,0.2]);,YTICKFORMAT='(g6.0)');, BACKGROUND_COLOR='light grey')

FOR ii=0,isonum DO BEGIN

  IF ii ne 0 THEN BEGIN
    nrep=98
    zeta_array = fltarr(nrep)
    CD, '/run/media/cns/3C87-68DE/shingledecker_et_al_2016/' + isoreps[ii-1]
    zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
    PRINT, isoreps[ii-1]
  ENDIF


  FOR r=1,nrep DO BEGIN
    PRINT, r

    ;IF ii eq 0 THEN BEGIN
    rep =   base_rep + STRTRIM(r-1,1)
    ;ENDIF ELSE BEGIN
    ;  rep = base_rep + STRTRIM(r-1,1)
    ;ENDELSE

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

      ;plot2 = plot( time_all/3.15e7,ab_select(*,0), $
      ;       linestyle=0,color=color_tab[species_color[s]], /OVERPLOT)

      ;leg = LEGEND(TARGET=[plot2], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=,/RELATIVE)
      ;leg = LEGEND(TARGET=[plot2], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)
      ;POSITION=[70,0.0000000001+(nsp-s-1)*0.000005+0.00001*(nsp-1-s)]
    endfor ;s

    ;plot3 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
    ;       linestyle=species_style[1], /OVERPLOT)


    ;IF ii eq 0 THEN BEGIN
    zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
    ;ENDIF ELSE BEGIN
    ;  zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
    ;ENDELSE
    out_array(r,*) = ab_select_1(*,0)/ab_select_2(*,0)

    ;PRINT, zeta_data.FIELD5[r-1]
    ;zetaColor = (zeta_data.FIELD1[r-1]-zetaMin)/(zetaMax - zetaMin)
    ;zetaColor = FIX(zetaColor*255)
    ;red = list_colors[zetaColor,0]
    ;green = list_colors[zetaColor,1]
    ;blue = list_colors[zetaColor,2]
    ;plot4 = plot( time_all/3.15e7,ab_select_1(*,0)/ab_select_2(*,0), $
    ;       linestyle=0,thick=0,color=[red,green,blue], /OVERPLOT )


    ;leg_name = species_tab[0] + '/' + species_tab[1]
    ;leg = LEGEND(TARGET=[plot3], POSITION=[0.2,0.8+s*0.1],/AUTO_TEXT_COLOR, LABEL=leg_name, FONT_NAME='Hershey 3', /RELATIVE)
    ;leg_name2 = species_tab[1] + '/' + species_tab[0]
    ;leg = LEGEND(TARGET=[plot4], POSITION=[0.2,0.2+r*0.1],/AUTO_TEXT_COLOR, LABEL=leg_label[r], /RELATIVE)

    ;PRINT, 'run',r,'of',nrep
  ENDFOR ;r


  ;Now do the same for the both data
  ;IF ii eq 0 THEN BEGIN
  danger = MAKE_ARRAY(2,nrep)
  rep_temp = make_array(nrep,value=isorep[r])
  danger[0,*] = zeta_data.FIELD5[0:nrep-1]
  danger[1,*] = zeta_array
  sortIndex = Sort( danger[0,*] )
  FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]
  out_df = [[out_df],[danger]]
  rep_df = [[rep_df],[rep_temp]]
  ;ENDIF ELSE BEGIN
  ;  danger = MAKE_ARRAY(2,nrep)
  ;  danger[0,*] = zeta_data.FIELD5[0:nrep-1]
  ;  danger[1,*] = zeta_array
  ;  sortIndex = Sort( danger[0,*] )
  ;  FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]
  ;ENDELSE

  ;PLOT, danger[0,*], $
  ;      danger[1,*], $
  ;      /xlog,/ylog, $
  ;      PSYM = 2, $
  ;      XTITLE = 'Cosmic ray ionization rate', $
  ;      YTITLE = '[HCO+]/[DCO+]', $
  ;      XMARGIN = [10,10],$
  ;      YMARGIN = [5,5], $
  ;      CHARSIZE = 2.0, $
  ;      FONT = 1, $
  ;      TITLE = '15 K (Gas and Grain), 1E4 density, 8E5 yr'

  ;IF ii eq 0 THEN BEGIN
  ;  plot1 = plot(danger[0,*]*1E17,danger[1,*], $;zeta_data.FIELD5[0:nrep-1]*1E17,zeta_array, $ ;
  ;  /xlog,/ylog, $ ;charsize=1.5, $
  ;  ytitle='['+species_tab[0]+']/['+species_tab[1] + ']', $
  ;  xtitle = '$\zeta$ x 10!E17!N s!E-1!N', $
  ;  xstyle=1,$
  ;  ystyle=1, $
  ;  TITLE='T=10 K, n!DH2!N=10!E5!N cm!E-3!N', $
  ;  ;  LINESTYLE=0, THICK=2, COLOR='red', $
  ;  SYMBOL='Circle', $
  ;  SYM_FILLED=1, SYM_SIZE=0.7, COLOR='black', LINESTYLE='6', $
  ;  FONT_NAME='Helvetica',FONT_SIZE=20, $
  ;  ASPECT_RATIO = 0.7, $
  ;  YRANGE=[ymin,ymax], $
  ;  XRANGE=[xmin,xmax], $
  ;  MARGIN=[0.15,0.15,0.1,0.15], $
  ;  YTICKNAME=['$10^{-1}$','$10^0$','$10^1$','$10^2$','$10^3$'])
  ;ENDIF ELSE BEGIN
  ;  plot2 = plot(danger[0,*]*1E17,danger[1,*], /OVERPLOT, $;zeta_data.FIELD5[0:nrep-1]*1E17,zeta_array, $ ;
  ;  xstyle=1,$
  ;  ystyle=1, $
  ;  LINESTYLE=0, THICK=2, COLOR=isocolor[ii-1])
  ;ENDELSE

ENDFOR ;ii

;leg = LEGEND(POSITION=[40,850],/DATA,FONT_NAME='Helvetica',FONT_SIZE=20)
;leg[0].label = 'Varied'
;leg[1].label = '0.01'
;leg[2].label = '0.1'
;leg[3].label = '3.0'

;cgplot, danger[0,*]*1E17,danger[1,*], $;zeta_data.FIELD5[0:nrep-1]*1E17,zeta_array, $ ;
;  /xlog,/ylog, $ ;charsize=1.5, $
;  xtitle='$\zeta$ x 10$\up17$ s$\up-1$',ytitle='['+species_tab[0]+']/['+species_tab[1] + ']', $
;  xstyle=1,$
;  ystyle=1, $
;;  TITLE='Abundance Ratio vs. $\zeta$ at 10$\up6$ yr T=10K & n$\downH2$=10$\up4$ cm$\up-3$)', $
;;  LINESTYLE=0, THICK=2, COLOR='red', $
;  PSYM=2, $
;  FONT=-1,CHARSIZE=1.5, $
;  YRANGE=[8,1E4], XRANGE=[1E-1,100];, /NODATA

;Add observational constraint regions
;xobs1 = [xmin,xmax,xmax,xmin]
;yobs1 = [obsmin,obsmin,obsmax,obsmax]
;poly1 = POLYGON(xobs1,yobs1,FILL_COLOR='blue',/DATA, $
;                TRANSPARENCY=50,/FILL_BACKGROUND)
;
;xobs2 = [7E-16,2E-15,2E-15,7E-16]
;yobs2 = [2E2,2E2,1E3,1E3]
;
;polyfill, xobs1,yobs1, COLOR=175
;polyfill, xobs2,yobs2, COLOR=175
;
;oplot, zeta_data.FIELD5[0:nrep-1],zeta_array,PSYM='2', COLOR=0,SYMSIZE=0.4
;tvlct, 255,0,0,125
;oplot, pure_zeta.FIELD1*1E17,pure_zeta.FIELD2,PSYM='2', COLOR='red',SYMSIZE=0.4

;c = CONTOUR(zeta_array ,1E17*zeta_data.FIELD2[0:nrep-1],zeta_data.FIELD1[0:nrep-1], /FILL,/XLOG,/YLOG,YRANGE=[0.001,3],RGB_TABLE=22)
;loadct, NUM_CT
;cb = COLORBAR(target=plot4, position=[0.2,0.82,0.9,0.87],/BORDER,ORIENTATION=0,$
;              RGB_TABLE=NUM_CT,RANGE=[zetaMin,zetaMax],$
;              TICKVALUES=[zetaMin,(zetaMax-zetaMin)/2.0,zetaMax],TEXTPOS=1, $
;              FONT_SIZE=16, THICK= 0.5,FONT_NAME='Hershey 3')
;PRINT, pure_zeta.FIELD2


;if aff eq 0 then begin
;  device,/close
;  set_plot,'x'
;  spawn, 'epstopdf '+ plot_name
;endif

;Make a 2d array containing the zeta and abundance ratio information
;pure = MAKE_ARRAY(2,nrep)
;pure[0,*] = pure_zeta.FIELD1
;pure[1,*] = pure_zeta.FIELD2
;Print, pure

; Sort the 2d array based on the values of the first column
;sortIndex = Sort( pure[0,*] )
;FOR j=0,1 DO pure[j, *] = pure[j, sortIndex]
;Print, "And the sorted data is:"
;Print, pure


;Now do the same for the both data
;danger = MAKE_ARRAY(2,nrep)
;danger[0,*] = zeta_data.FIELD5[0:nrep-1]
;danger[1,*] = zeta_array
;sortIndex = Sort( danger[0,*] )
;FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]


;CD, 'C:\Users\Christopher\Documents\GitHub\idl_scripts'
;PRINT, 'Max zeta=',zeta_error_max
;PRINT, 'Min zeta=',zeta_error_min
;PRINT, 'Max is greater than min by a factor of',zeta_error_max/zeta_error_min
;PRINT, 'Ending script!'

write_csv, '/home/cns/Desktop/f6a.csv',out_df,rep_df
print, ab_select_1(*,0)/ab_select_2(*,0)

end