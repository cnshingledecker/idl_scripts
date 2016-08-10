; === PARAMETERS ==========================================
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

NUM_CT = 2

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
time_num = 70

isoreps = ['0_01_L1174_opr_fixed','0_1_L1174_opr_fixed','3_L1174_opr_fixed']
isolabel = ['Varied','0.01','0.1','3']
isonum = SIZE(isoreps, /N_ELEMENTS)
nrep = 214;SIZE(rep, /N_ELEMENTS)
out_csv_name = "hco+_dco+_both_opr.csv"
base_rep = 'both_run_'
PRINT, "The number of reps is",nrep

zeta_array = fltarr(nrep)
out_df = fltarr(2,1)
rep_df = make_array(1,1,value="Null")

CD, '/home/cns/jenny_project/reduced_L1174'
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


FOR ii=0,isonum DO BEGIN
  
  IF ii ne 0 THEN BEGIN
    nrep=98
    zeta_array = fltarr(nrep)
    CD, '/home/cns/jenny_project/' + isoreps[ii-1]
    zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)
    PRINT, isoreps[ii-1], ii
  ENDIF


  FOR r=1,nrep DO BEGIN
    IF (r EQ 134) THEN GOTO, JUMP1
    IF ( ii EQ 2 AND r EQ 6 ) THEN GOTO, JUMP1

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

    endfor ;s



    ;IF ii eq 0 THEN BEGIN
    zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
    ;ENDIF ELSE BEGIN
    ;  zeta_array(r-1) = ab_select_1(time_num,0)/ab_select_2(time_num,0)
    ;ENDELSE
    out_array(r,*) = ab_select_1(*,0)/ab_select_2(*,0)

    JUMP1: PRINT, r
  ENDFOR ;r


  ;Now do the same for the both data
  ;IF ii eq 0 THEN BEGIN
  danger = MAKE_ARRAY(2,nrep)
  print, ii
  rep_temp = make_array(1,nrep,value=isolabel[ii])
  danger[0,*] = zeta_data.FIELD5[0:nrep-1]
  danger[1,*] = zeta_array
  sortIndex = Sort( danger[0,*] )
  FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]
  out_df = [[out_df],[danger]]
  rep_df = [[rep_df],[rep_temp]]

;  JUMP2: PRINT, ii
ENDFOR ;ii

df = CREATE_STRUCT('Zeta',out_df[0,*],'Ratio',out_df[1,*],'Type',rep_df[0,*])
write_csv, '/home/cns/Desktop/f6c.csv',df
PRINT, 'Ending script!'
end