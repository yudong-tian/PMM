
# rename the strange files for snowdepth  and swe

cd 201501

day0='1 Jan 2015'
for day in `seq 1 8`; do 
  let aday=day-1
  ymd=`date -d "$day0 + $aday day" +%Y%m%d`
  mv us_ssmv11036tS__T0001TTNATS${ymd}05HP001.dat snd_$ymd.1gd2i
  mv us_ssmv11034tS__T0001TTNATS${ymd}05HP001.dat swe_$ymd.1gd2i
  # unmasked 
  #mv zz_ssmv11036tS__T0001TTNATS${ymd}05HP001.dat snd_$ymd.1gd2i
  #mv zz_ssmv11034tS__T0001TTNATS${ymd}05HP001.dat swe_$ymd.1gd2i
done

  
