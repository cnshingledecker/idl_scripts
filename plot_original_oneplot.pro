@read_re_abundances
@legend
PRO SP_IDX, spe, sp, nspe
	n_spe = n_elements(spe)
	nspe = 0
	FOR i = 0, n_spe - 1 DO IF (strcompress(spe(i), /remove_all) EQ sp) THEN nspe = i
END


data_path = "/home/cns/Documents/Dropbox/office_code/results_0.idl"

fig_path = "~/Desktop/"



set_plot, 'PS'

!p.multi = [1,1,1,0,0]
device, file = fig_path+'fig.ps',  /inches, bits = 32, /color, /landscape, xsize=10, ysize=5

sp2plot = ['CO', 'CO2', 'HCN', 'CH3OH', 'H2O', 'CH4']
sp2plot_print = ['CO', 'CO2', 'HCN', 'CH3OH', 'H2O', 'CH4']

linestyles = intarr(n_elements(sp2plot))
n_sp = intarr(n_elements(sp2plot))

read_re_abundances, data_path, species, ns, t_re, nstep_re, ab_re, hdens, rr, zz
t_re = t_re/3.155e7

FOR i = 0, n_elements(sp2plot)-1 DO BEGIN
  sp_idx, species, sp2plot(i), n_spt
  n_sp(i) = n_spt
ENDFOR


plot, t_re, ab_re(0:nstep_re-1,n_sp(0)), /xlog, /ylog, xrange = [1d4, 1d8], yrange = [1d-14, 1d-3], linestyle = 0, charsize = 1, xtitle="t, years", ytitle="n(X)/n!DH!N", xstyle=1

linestyles(0) = 0

for i = 1, n_elements(n_sp)-1 do begin

  oplot, t_re, ab_re(0:nstep_re-1,n_sp(i)), linestyle = i
  linestyles(i) = i

endfor
legend, sp2plot_print, linestyle = linestyles, position = [0.1,0.9], /normal



linestyles(0) = 0

for i = 1, n_elements(n_sp)-1 do begin

  oplot, t_re, ab_re(0:nstep_re-1,n_sp(i)), linestyle = i
  linestyles(i) = i

endfor


device, /close

set_plot, 'X'

plot, t_re, ab_re(0:nstep_re-1,n_sp(0)), /xlog, /ylog, xrange = [1d4, 1d8], yrange = [1d-14, 1d-3], $
  linestyle = 0, charsize = 1.5, xtitle="t, years", ytitle="n(X)/n!DH!N", xstyle=1

linestyles(0) = 0

for i = 1, n_elements(n_sp)-1 do begin

  oplot, t_re, ab_re(0:nstep_re-1,n_sp(i)), linestyle = i
  linestyles(i) = i

endfor

legend, sp2plot_print, linestyle = linestyles, position = [0.18,0.92], /normal



linestyles(0) = 0

for i = 1, n_elements(n_sp)-1 do begin

  oplot, t_re, ab_re(0:nstep_re-1,n_sp(i)), linestyle = i
  linestyles(i) = i

endfor

close, /all

print, 'Done.'

END
