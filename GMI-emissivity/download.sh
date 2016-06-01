
# download Joe Munchak's GMI retrievals 
odir=/home/ytian/GPM/GMI-emissivity

# monthly directory, 12 months total
sdate="Sep 1 2014"
#edate="Aug 1 2015"
nmonths=12

let nm=nmonths-1 

for im in `seq 0 $nm`; do 

 cyr=`date -u -d "$sdate + $im months" +%Y`
 cmn=`date -u -d "$sdate + $im months" +%m`
 cymd=`date -u -d "$sdate $id days" +%Y%m%d`
 od=$odir/$cyr/$cmn
 if [ ! -d $od ]; then
   mkdir -p $od
 fi

 cd $od

 wget -nd -nH ftp://meso-a.gsfc.nasa.gov/pub/munchak/gpm/emis/$cyr/$cmn/*.gz

done 

