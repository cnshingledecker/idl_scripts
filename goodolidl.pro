PRO goodolidl

ptype = 0


IF (ptype EQ 1 ) THEN BEGIN
  SET_PLOT, 'PS'
  name = '/home/cns/Desktop/gas_sgrb2n_joanna1.eps'
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

AB_DIR = 'ab/'

read1 = AB_DIR + file1
read2 = AB_DIR + file2

data1 = READ_CSV(read1,N_TABLE_HEADER=1)
data2 = READ_CSV(read2,N_TABLE_HEADER=1)

ratio = data1.FIELD2/data2.FIELD2
;PRINT, ratio
PRINT, MAX(data1.FIELD2)
PRINT, "********************************"
PRINT, MAX(data2.FIELD2)
PRINT, '********************************"
PRINT, MAX(data1.FIELD2)/MAX(data2.FIELD2)            

plot1 = PLOT(data1.FIELD1,data1.FIELD2, /XLOG, /YLOG,FONT_NAME='Hershey', $
        TITLE='T$_{gas}$=10K, T$_{grain}$=10 K', $
        YRANGE=[1E-30,1E-5],XRANGE=[1,1E9], $
        XTITLE="Time (yr)",YTITLE="n(X)/n(H2)");,title="CH3CHO & CH2CHOH w/o Irradiation w/o Conversion"
plot2 = PLOT(data2.FIELD1,data2.FIELD2, linestyle=1, /OVERPLOT)
;poly = POLYGON([data1.FIELD1,REVERSE(data1.FIELD1)],[data1.FIELD2,REVERSE(data2.FIELD2)],/DATA,/FILL_BACKGROUND, $
;  FILL_COLOR="light gray", LINESTYLE=0)

;PLOT, data1.FIELD1,ratio,/XLOG,/YLOG

WRITE_CSV, 'densecloud_norads_data.csv',data1.FIELD1,data1.FIELD2,data2.FIELD2,HEADER=['time','CH3CHO','CH2CHOH'],$
  TABLE_HEADER=['Relative abundances of acetaldehyde and vinyl alcohol for a cold core, obtained withouth using radiation chemistry']
IF ( ptype EQ 1 ) THEN BEGIN
  device, /close
  SET_PLOT, 'X'
  spawn, 'epstopdf '+ name
ENDIF
  
END
