PRO colsort
; This script sorts a multi-dimensional array of data
; based on the values of 1 column, keeping XYZ values 
; together.

seed = -1L
data = Fix(RandomU(seed, 3, 10) * 100)
Print, "The unsorted data is:"
Print, data
sortIndex = Sort( data[0,*] )
FOR j=0,2 DO data[j, *] = data[j, sortIndex]
Print, "And the sorted data is:"
Print, data
END