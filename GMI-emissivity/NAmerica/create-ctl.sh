
#ga-> set x 221 480
#LON set to -124.875 -60.125
#ga-> set y 461 620
#LAT set to 25.125 64.875
lat0=25.125
lon0=-124.875
nx=260
ny=160

for m in M1 M2 M3 M4 M5; do 

cat > ${m}_errors.ctl <<EOF
DSET ^${m}-errors.13gd4r
options template  big_endian
TITLE model fitting errors 
UNDEF -9999.0 
XDEF   $nx LINEAR  $lon0  0.250
YDEF   $ny LINEAR  $lat0  0.250
ZDEF 1    LINEAR 1 1
TDEF 1    LINEAR 0Z01sep2014 24hr
VARS 13
err11V         1  99  **  1 ssm/i 19.35  Ghz V-pol
err11H         1  99  **  1 ssm/i 19.35  Ghz H-pol
err19V         1  99  **  1 ssm/i 19.35  Ghz V-pol
err19H         1  99  **  1 ssm/i 19.35  Ghz H-pol
err24V         1  99  **  1 ssm/i 22.235 Ghz H-pol
err37V         1  99  **  1 ssm/i 37.0   Ghz V-pol
err37H         1  99  **  1 ssm/i 37.0   Ghz H-pol
err89V         1  99  **  1 ssm/i 85.5   Ghz V-pol
err89H         1  99  **  1 ssm/i 85.5   Ghz H-pol
err166V         1  99  **  1 ssm/i 85.5   Ghz V-pol
err166H         1  99  **  1 ssm/i 85.5   Ghz H-pol
err183V3         1  99  **  1 ssm/i 85.5   Ghz H-pol
err183V7         1  99  **  1 ssm/i 85.5   Ghz H-pol
ENDVARS
EOF

done

