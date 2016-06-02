
#t0="Jan 1 2015"   # starting time: 0Z
#t1="Jan 31 2015"   # end time: 0Z
t0="Jul 1 2015"   # starting time: 0Z
t1="Jul 31 2015"   # end time: 0Z

sec0=`date -u -d "$t0" +%s`
sec1=`date -u -d "$t1" +%s`
let days=(sec1-sec0)/86400

for day in `seq 0 $days`; do
  t1=`date -u -d "$t0 $day day"`  # for new "date" command
  cyr=`date -u -d "$t1" +%Y`
  cmn=`date -u -d "$t1" +%m`
  cdy=`date -u -d "$t1" +%d`
  ymd=`date -u -d "$t1" +%Y%m%d`

  ddir=bin_$cyr$cmn
  mkdir $ddir 

  ls $cyr/$cmn/GPM.${ymd}* > $ddir/${ymd}.list 
  ./reproj $ddir/${ymd}.list $ddir/${ymd}.13gd4r
  rm $ddir/${ymd}.list

done 

