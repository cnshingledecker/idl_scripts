; === PARAMETERS ==========================================
!PATH = Expand_Path('+~/Dropbox/coyote/') + ':' + !PATH

varied = '001_to_3_OPR'
ntime = 81
npoint = 1
ns = 1574

species_tab=['HCO+','DCO+']
species_style=[0,1]

output_per_decade = 10
decade = 7
time_num = decade*output_per_decade + 1
time_num = 51

;isoreps = ['0_01_fixed_OPR','0_1_fixed_OPR','3_fixed_OPR']
isoreps = ['0_01_L1174_opr_fixed','0_1_L1174_opr_fixed','3_L1174_opr_fixed']
isonum = SIZE(isoreps, /N_ELEMENTS)
nrep = 214;SIZE(rep, /N_ELEMENTS)
base_rep = 'both_run_'
PRINT, "The number of reps is",nrep

out_array = fltarr(nrep+1,ntime)
zeta_array = fltarr(nrep)
out_df = fltarr(2,1)
rep_df = make_array(1,value="X")

CD, '/run/media/cns/3C87-68DE/shingledecker_et_al_2016/reduced_L1174'
;CD, 'E:\jenny_project\variational_analysis\105_dens_at_10K\'

zeta_data = READ_CSV('both.out',N_TABLE_HEADER=0)


; === IDL/GDL CODE ========================================

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
        result = FILE_TEST(char, /READ)
        if result eq 1 then begin
          openr,1,char, /f77_unformatted
          readu,1,time
          time_all(i)=time
          out_array(0,i) = time/3.15e7
          readu,1,temp,dens,tau
          readu,1,ab
          ab_select(i,*) = ab(index,*)
          close,1
        endif else begin
          print, "FAILURE!"
          continue
        endelse
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

  ENDFOR ;r

  IF ii eq 0 THEN BEGIN
    danger = MAKE_ARRAY(2,nrep)
    rep_temp = make_array(nrep,value=isoreps[ii])
    danger[0,*] = zeta_data.FIELD5[0:nrep-1]
    danger[1,*] = zeta_array
    sortIndex = Sort( danger[0,*] )
    FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]
    out_df = [[out_df],[danger]]
    rep_df = [[rep_df],[rep_temp]]
  ENDIF ELSE BEGIN
    danger = MAKE_ARRAY(2,nrep)
    danger[0,*] = zeta_data.FIELD5[0:nrep-1]
    danger[1,*] = zeta_array
    sortIndex = Sort( danger[0,*] )
    FOR j=0,1 DO danger[j, *] = danger[j, sortIndex]
  ENDELSE

endfor ;ii

write_csv, '/home/cns/Desktop/f6a.csv',out_df,rep_df
print, ab_select_1(*,0)/ab_select_2(*,0)

end