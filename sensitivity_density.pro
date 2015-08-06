PRO sensitivity_density

!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH
ntime = 71
nrep = 324 
nbin = 10
ymax = 1E-1
ymin = 1E-5
infile = 'abundances.csv'
npoint = 1
ns = 1574

species_tab=['DCO+','HCO+']
species_style=[0,1]

style1 = 0
style2 = 2

range_time = [1e0,1e7]
;range_abundance = [0,1]
range_abundance = [ymin,ymax]

; === IDL/GDL CODE ========================================

device,decomposed=0
LOADCT, 0
cgLoadCT, 0

plot_name = 'block_graph.eps'
set_plot, 'x'


read,'eps (0) or screen (1)',aff
if aff eq 0 then begin
  set_plot,'ps'
  device, xsize=20,ysize=15,filename=plot_name,scale_factor=0.5, /landscape
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


plot, time_all/3.15e7,ab_select(*,0), $
  /xlog,/ylog, $ ;charthick=2, $ ;charsize=1.5, $
  xtitle='time [yr]',ytitle='abundances [/n!DH!N]', $
  xstyle=1, xrange=range_time, $
  ystyle=1, yrange=range_abundance, $
  /NODATA, color=0, BACKGROUND=255,XMARGIN=[10,11],CHARSIZE=1.5

ab_data = READ_CSV(infile, N_TABLE_HEADER=0)


tprev = 0
;inc = 0
;maxbin = 10000
;ynums = 100000
;FOR i=1,maxbin DO BEGIN
;  inc = inc + 0.01
;  y = FLTARR(ynums)
;  FOR k=0,ynums-1 DO BEGIN
;    y[k] = 10^((1-inc)*ALOG10(ymin) + (inc)*ALOG10(ymax))
;  ENDFOR
;  oplot, y
;ENDFOR

print, 'STARTING PLOT'
FOR i=0,ntime-1 DO BEGIN
  yprev = 0
  ycur  = 0
  yinc  = 0
  incval = 0.01
  temp_data = ab_data.(i)
  time = temp_data[0]
  data = temp_data[1:SIZE(temp_data,/N_ELEMENTS)-1]
    WHILE ( ycur LT ymax ) DO BEGIN
      ycur = 10^((1-yinc)*ALOG10(ymin) + (yinc)*ALOG10(ymax))
;      print, ycur,yprev
      yinc = yinc + incval
      counter = 0
      FOR k=0,nrep-1 DO BEGIN
;        print, data[k]
        IF ( data[k] GT yprev ) AND ( data[k] LE ycur ) THEN BEGIN
          counter = counter + 1
        ENDIF
      ENDFOR
      x = [tprev,time,time,tprev]
      y = [yprev,yprev,ycur,ycur]
      IF ( counter NE 0 ) THEN PRINT, counter,yprev,ycur
      frac = (counter*1.d0)/(nrep*1.d0)
      colour = LONG((1.d0-frac)*255)
      cgColorFill, x,y,COLOR=colour
      yprev = ycur
    ENDWHILE
  tprev = time
ENDFOR

plot, time_all/3.15e7,ab_select(*,0), $
  /xlog,/ylog, $ ;charthick=2, $ ;charsize=1.5, $
  xtitle='time [yr]',ytitle='abundances [/n!DH!N]', $
  xstyle=1, xrange=range_time, $
  ystyle=1, yrange=range_abundance, $
  /NODATA, color=0, BACKGROUND=255, /NOERASE, TITLE=' ',XMARGIN=[10,11],CHARSIZE=1.5


cgColorbar, Range = [100,0],FORMAT='(I3)',TITLE='% of Total Solutions',POSITION= [0.95, 0.10, 0.99, 0.90],/VERTICAL,/REVERSE


if aff eq 0 then begin
  device,/close
  set_plot,'x'
  spawn, 'epstopdf '+plot_name
endif

PRINT, 'Ending script'

END
