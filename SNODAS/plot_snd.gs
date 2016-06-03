
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


ttl.1='1Jan2015' 
ttl.2='3Jan2015' 
ttl.3='5Jan2015' 
ttl.4='7Jan2015' 

var.1='snd/1000'
var.2='snd/1000' 
var.3='snd/1000' 
var.4='snd/1000' 

levs='0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0' 

'open snd.ctl'

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

'set time 'ttl.id 
'set clevs 'levs
*'d 'var.id
'd re('var.id', 232, linear, -124.875, 0.25, 112, linear, 25.125, 0.25)'
'cbarn' 
'draw title Snow Depth (m) 'ttl.id

 ic=ic+1
 endwhile
ir=ir+1
endwhile
'printim sm-snd-jan-2005.png png x1000 y750 white' 
'printim snd-jan-2005.png png x4000 y3000 white' 
*'gxyat -x 1000 -y 750 sm-snd-jan-2005.png'
*'gxyat -x 4000 -y 3000 snd-jan-2005.png'


