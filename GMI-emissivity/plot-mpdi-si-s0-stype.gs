
* show MPDI, SI, S0 (Ku) and Surface type
*landscape

'reinit'

*number of time steps
tmax=12

lon1=-125
lon2=-60
lat1=20 
lat2=60 

cols=2
rows=2
hgap=0.1
vgap=0.2
vh=8.5/rows
vw=11/cols


parea='0.7 10.4 0.9 7.9'

ttl.1='MPDI*600' 
ttl.2='Tb19V-Tb37V' 
ttl.3='Sigma0 (Ku)' 
ttl.4='Surf Type' 

*ip
ttldate.1='1-8 Jan2005'
ttldate.2='1-8 Jul2005'

var.1='(tb11v-tb11h)/(tb11v+tb11h)*600'  
var.2='tb19v-tb37v' 
var.3='s0ku' 
var.4='surftype' 

levs.1='0 5 10 15 20 25 30 35 40 45 50 55 60' 
levs.2='-10 -5 0 5 10 15 20 25 30' 
levs.3='-15 -12  -9 -6 -3 0 3 6 9 12 15' 
levs.4='1 2 3 4 5 6 7 8 9 10 11 12 13 14' 

* .ip
d0.1='1Jan2015'
d1.1='8Jan2015'

d0.2='1Jul2015'
d1.2='8Jul2015'

'open emis.ctl'

ip=1
while (ip <= 2) 
 'c'

ir=1
while (ir <= rows)
 ic=1
 while (ic <= cols)
 
 id=(ir-1)*cols+ic

*compute vpage
 vx1=(ic-1)*vw+hgap
 vx2=ic*vw-hgap
 vy1=(rows-ir)*vh+vgap
 vy2=vy1+vh-vgap

'set vpage 'vx1' 'vx2' 'vy1' 'vy2
'set grads off'
'set parea 'parea
'set xlopts 1 0.5 0.15'
'set ylopts 1 0.5 0.15'
'set lat 'lat1' 'lat2
'set lon 'lon1' 'lon2
'set gxout grfill' 
'set mpdset hires'

'set time 'd0.ip' 'd1.ip
'q dims' 
line=sublin(result, 5) 
t0=subwrd(line, 11) 
t1=subwrd(line, 13) 

* loop through time
 while (t0 <= t1) 
  'set t 't0 
  'set clevs 'levs.id
  'd 'var.id
  t0=t0+1
 endwhile 
 'cbarn' 
 'draw title 'ttl.id' 'ttldate.ip

 ic=ic+1
 endwhile
ir=ir+1
endwhile
*'gxyat -x 4000 -y 3000 mpdi-si-s0-stype-'d0.ip'.png'
*'gxyat -x 1000 -y 750 sm-mpdi-si-s0-stype-'d0.ip'.png'
*'gxprint mpdi-si-s0-stype-'d0.ip'.png x4000 y3000 white'
*'gxprint sm-mpdi-si-s0-stype-'d0.ip'.png x1000 y750 white'
'printim sm-mpdi-si-s0-stype-'d0.ip'.png png x1000 y750 white'
'printim mpdi-si-s0-stype-'d0.ip'.png png x4000 y3000 white'

ip=ip+1
endwhile

