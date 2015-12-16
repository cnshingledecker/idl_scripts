PRO goodolidl


SET_PLOT, 'PS'
name = 'CH3CHO_CH2CHOH_SgrB2N.eps'
DEVICE, FILENAME=name, /landscape
!X.MARGIN=[10,10]
!Y.MARGIN=[5,5]
  
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
PRINT, data1.FIELD2

PLOT, data1.FIELD1,data1.FIELD2, /XLOG, /YLOG
OPLOT, data2.FIELD1,data2.FIELD2, linestyle=1

;PLOT, data1.FIELD1,ratio,/XLOG,/YLOG

device, /close
set_plot,'x'
spawn, 'epstopdf '+ name
END
