PRO errorsplot

ptype = 1


IF (ptype EQ 1 ) THEN BEGIN
  SET_PLOT, 'PS'
  name = '/home/cns/Desktop/gas_sgrb2n_norads.eps'
  DEVICE, FILENAME=name, /landscape
  !X.MARGIN=[10,10]
  !Y.MARGIN=[5,5]
ENDIF ELSE BEGIN
  SET_PLOT, 'X'
ENDELSE
  
species1 = 'CH3CHO'
species2 = 'CH2CHOH'

file1 = species1 + '.csv'
file2 = species2 + '.csv'

PRINT, species1,',',file1
PRINT, species2,',',file2

baserep = './'
dirs = ['high','low','mid']

FOR i=0,2 DO BEGIN

AB_DIR = baserep + dirs[i] + '/ab/'

read1 = AB_DIR + file1
read2 = AB_DIR + file2

data1 = READ_CSV(read1,N_TABLE_HEADER=1)
data2 = READ_CSV(read2,N_TABLE_HEADER=1)

IF i EQ 0 THEN BEGIN
  highdat1 = data1.FIELD2
  highdat2 = data2.FIELD2
ENDIF ELSE IF i EQ 1 THEN BEGIN
  lowdat1 = data1.FIELD2
  lowdat2 = data2.FIELD2
ENDIF

ENDFOR

times = data1.FIELD1
ab1 = data1.FIELD2
ab2 = data2.FIELD2
ratio = data1.FIELD2/data2.FIELD2
;PRINT, ratio
PRINT, MAX(data1.FIELD2)
PRINT, "********************************"
PRINT, MAX(data2.FIELD2)
PRINT, '********************************"
PRINT, MAX(data1.FIELD2)/MAX(data2.FIELD2)            

baseplot = PLOT(data1.FIELD1,data1.FIELD2, /XLOG, /YLOG, $
;                XRANGE=[3E5,1E7],YRANGE=[1E-14,1E-11],$      
                XTITLE="Time (yr)",YTITLE="n$_X$/n$_{H2}$",/NODATA, FONT_NAME='Hershey',FONT_SIZE=20);,title="CH3CHO & CH2CHOH w/o Irradiation w/o Conversion"
poly1 = POLYGON([times,REVERSE(times)],[highdat1,REVERSE(lowdat1)],/DATA,/FILL_BACKGROUND, $
  FILL_COLOR="light gray", TRANSPARENCY=50 )
poly2 = POLYGON([times,REVERSE(times)],[highdat2,REVERSE(lowdat2)],/DATA,/FILL_BACKGROUND, $
  FILL_COLOR="light gray", TRANSPARENCY=50 )
;plot1 = PLOT(data1.FIELD1,data1.FIELD2, linestyle=1, /OVERPLOT)
;plot2 = PLOT(data2.FIELD1,data2.FIELD2, linestyle=1, /OVERPLOT)
plot1 = PLOT(times,ab1,linestyle=0,/OVERPLOT,NAME='CH3CHO')
plot2 = PLOT(times,ab2,linestyle=1,/OVERPLOT,NAME='CH2CHOH')
;leg = LEGEND(TARGET=[plot1,plot2],POSITION=[0.95,0.95],/RELATIVE)
;plot2 = PLOT(times,highdat1,linestyle=1,/OVERPLOT)
;plot3 = PLOT(times,lowdat1,linestyle=1,/OVERPLOT)

WRITE_CSV, 'sgrb2n_norads_data.csv',data1.FIELD1,data1.FIELD2,data2.FIELD2,highdat1,highdat2,lowdat1,lowdat2,HEADER=['time','CH3CHO-mid','CH2CHOH-mid','CH3CHO-high','CH2CHOH-high',$
           'CH3CHO-low','CH2CHOH-low'], $
           TABLE_HEADER=['Relative abundances of acetaldehyde and vinyl alcohol for SgrB2(N), obtained using high-low-and mid values of experimental data']

IF ( ptype EQ 1 ) THEN BEGIN
  device, /close
  SET_PLOT, 'X'
  spawn, 'epstopdf '+ name
ENDIF
  
END
