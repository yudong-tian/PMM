
# 7/18/16: Copied from /home/ytian/lswg/AMSR_E_Emis_Sarah/PMM-2014
# Here to test prediction performance over the globe with Joe's emissivity 
# data. Since the data are only for 1 year (9/2014 - 8/2015), we do not
# split the data into model-fitting and model-validation parts. Instead, 
# we just check the model-fitting performance for now. 

# Try all kinds of predictors permutated from the following set:   
# Tb_V (5 freqs), Tb_H(5), Tb_V^2 (5), Tb_H^2 (5), and MPDI (5) 

library(fields) 

plot_err <- function(lon, lat, errs, method) {

par(mfcol=c(2,4), mai=c(0.6, 0.3, 0.3, 0.1))
par(bg="white")

#  prediction error
image.plot(lon, lat, errs[ , , 1], main="error*100 (11V)", horizontal=T, zlim=c(0, 5),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
image.plot(lon, lat, errs[ , , 3], main="error*100 (19V)", horizontal=T, zlim=c(0, 5),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
#image.plot(lon, lat, errs[ , , 7], main="error*100 (24V)", horizontal=T, zlim=c(0, 5),
# axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
image.plot(lon, lat, errs[ , , 6], main="error*100 (37V)", horizontal=T, zlim=c(0, 5),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
image.plot(lon, lat, errs[ , , 8], main="error*100 (89V)", horizontal=T, zlim=c(0, 8),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )

image.plot(lon, lat, errs[ , , 2], main="error*100 (11H)", horizontal=T, zlim=c(0, 5),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
image.plot(lon, lat, errs[ , , 4], main="error*100 (19H)", horizontal=T, zlim=c(0, 5),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
#image.plot(lon, lat, errs[ , , 8], main="error*100 (24H)", horizontal=T, zlim=c(0, 5),
# axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
image.plot(lon, lat, errs[ , , 7], main="error*100 (37H)", horizontal=T, zlim=c(0, 5),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )
image.plot(lon, lat, errs[ , , 9], main="error*100 (89H)", horizontal=T, zlim=c(0, 8),
 axis.args=list(cex.axis=2), cex.axis=2, cex.main=2, xlab="", ylab="" )

dev.copy(postscript, paste(method, "-spatial-err.ps", sep=""), horizontal=T)
dev.off()

}

nc=1440
nr=720
nt=365
nch=29
lon0=-179.875
lat0=-89.875
nch=29

#subset to a region

lon=seq(60.125, 129.875, 0.25) 
lat=seq(10.125, 64.875, 0.25) 
nx=(lon-lon0)/0.25+1
ny=(lat-lat0)/0.25+1

#X is varying   Lon = 60.125 to 129.875   X = 961 to 1240
#Y is varying   Lat = 10.125 to 64.875   Y = 401 to 620

# data line-up: 
#VARS 29
#1 em11V         1  99  **  1 ssm/i 19.35  Ghz V-pol
#2 em11H         1  99  **  1 ssm/i 19.35  Ghz H-pol
#3 em19V         1  99  **  1 ssm/i 19.35  Ghz V-pol
#4 em19H         1  99  **  1 ssm/i 19.35  Ghz H-pol
#5 em24V         1  99  **  1 ssm/i 22.235 Ghz H-pol
#6 em37V         1  99  **  1 ssm/i 37.0   Ghz V-pol
#7 em37H         1  99  **  1 ssm/i 37.0   Ghz H-pol
#8 em89V         1  99  **  1 ssm/i 85.5   Ghz V-pol
#9 em89H         1  99  **  1 ssm/i 85.5   Ghz H-pol
#10 em166V         1  99  **  1 ssm/i 85.5   Ghz V-pol
#11 em166H         1  99  **  1 ssm/i 85.5   Ghz H-pol
#12 em183V3         1  99  **  1 ssm/i 85.5   Ghz H-pol
#13 em183V7         1  99  **  1 ssm/i 85.5   Ghz H-pol
#14 tb11V         1  99  **  1 ssm/i 19.35  Ghz V-pol
#15 tb11H         1  99  **  1 ssm/i 19.35  Ghz H-pol
#16 tb19V         1  99  **  1 ssm/i 19.35  Ghz V-pol
#17 tb19H         1  99  **  1 ssm/i 19.35  Ghz H-pol
#18 tb24V         1  99  **  1 ssm/i 22.235 Ghz H-pol
#19 tb37V         1  99  **  1 ssm/i 37.0   Ghz V-pol
#20 tb37H         1  99  **  1 ssm/i 37.0   Ghz H-pol
#21 tb89V         1  99  **  1 ssm/i 85.5   Ghz V-pol
#22 tb89H         1  99  **  1 ssm/i 85.5   Ghz H-pol
#23 tb166V         1  99  **  1 ssm/i 85.5   Ghz V-pol
#24 tb166H         1  99  **  1 ssm/i 85.5   Ghz H-pol
#25 tb183V3         1  99  **  1 ssm/i 85.5   Ghz H-pol
#26 tb183V7         1  99  **  1 ssm/i 85.5   Ghz H-pol
#27 s0ka        1  99  **  1 ssm/i 85.5   Ghz H-pol
#28 s0ku        1  99  **  1 ssm/i 85.5   Ghz H-pol
#29 surftype        1  99  **  1 ssm/i 85.5   Ghz H-pol
#ENDVARS

data=array(NA, dim=c(length(nx), length(ny), nch, nt), dimnames=c("nx", "ny", "channel", "time"))

# read daily data for 1 year (365 days, 9/1/14-8/31/15)
d1=as.Date("2014-09-01")

for (iday in 1:nt) {
   dfile=format(d1+iday-1, "../bin_%Y%m/%Y%m%d.13gd4r")
   print(paste("reading ", dfile))

   to.read=file(dfile, "rb")
   x =readBin(to.read, numeric(), n=nc*nr*nch, size=4, endian="big")
   close(to.read)
   x[x==-99.0]=NA
   xtemp =array(x, c(nc, nr, nch)) 
   data[ , , , iday] =xtemp[nx, ny, ]   #subset
}

ems = data[, , 1:13, ]      # emissivities 
tbs = data[, , 14:26, ]     # Tbs 

# Use 5 frequencies of V, 11, 19, 24, 37, and 89 GHz
# Use 4 frequencies of H: 11, 19, 37, and 89 GHz. 
# Four MPDIs: 11, 19, 37, and 89 (No 24GHz as it does not have H-Pol). 
tbV=tbs[, , c(1, 3, 6, 8), ]   # 11, 19, 37, 89
tbH=tbs[, , c(2, 4, 7, 9), ]
tbVa=tbs[, , c(1, 3, 5, 6, 8), ]   # 11, 19, 24, 37, 89 

# Channel line-up now for V and H
#1 11V
#2 19V
#3 24V
#4 37V
#5 89V

#1 11H
#2 19H
#3 37H
#4 89H

tbV2=tbVa**2 
tbH2=tbH**2 
mpdi=(tbV-tbH)/(tbV+tbH) 
mpdi2=mpdi**2 

nems=13   # how many emissivity channels to predict

errs1=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs2=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs3=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs4=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs5=array(-9999.0, dim=c(length(nx), length(ny), nems))

for (ich in 1:nems) { 
 print(paste("ich=", ich))
 for (ir in 1:length(ny) ) {
  print(paste("ir=", ir))
  for (ic in 1:length(nx) ) {

   # regression predictor set
   # all channels in x
   xtbV =   tbVa[ic, ir, , ]
   xtbH =   tbH[ic, ir, , ]
   xtbV2 = tbV2[ic, ir, , ]
   xtbH2 = tbH2[ic, ir, , ]
   xmpdi = mpdi[ic, ir, , ]
   xmpdi2 = mpdi2[ic, ir, , ]

   # one freq in y
   yem = ems[ic, ir, ich, ]

  ym = na.omit( yem )
  if (length(ym) > 10 ) {   # do only with enough samples

   # method 1: single channel MPDI: 10G  and its square (2-predictor)
   x=t( rbind(xmpdi[1, ], xmpdi2[1, ]) ) 
   model = lm(yem ~ x)  
   errs1[ic, ir, ich]=sqrt( mean( (residuals(model))^2 ) )

   # method 2: four-channel MPDI: 10~89G, linear terms only (4-predictor) 
   x=t( rbind(xmpdi) )
   model = lm(yem ~ x)
   errs2[ic, ir, ich]=sqrt( mean( (residuals(model))^2 ) )

   # method 3: 9-channel Tbs: 10~89G, linear terms only (9-predictor) 
   x=t(rbind(xtbV, xtbH) )
   model = lm(yem ~ x)
   errs3[ic, ir, ich]=sqrt( mean( (residuals(model))^2 ) )

   # method 4: 9-channel Tb and 4-channel MPDI, linear terms only (13-predictor) 
   x=t(rbind(xtbV, xtbH, xmpdi) )   # 5+4+4
   model = lm(yem ~ x)
   errs4[ic, ir, ich]=sqrt( mean( (residuals(model))^2 ) )

   # method 5: 9-channel Tb, 9-channel Tb^2, and 4-channel MPDI (22-predictor) 
   x=t(rbind(xtbV, xtbH, xtbV2, xtbH2, xmpdi) )   # 5+4+5+4+4
   model = lm(yem ~ x)
   errs5[ic, ir, ich]=sqrt( mean( (residuals(model))^2 ) )
  } # end if 

  }
 }
}

#save the data in binary file
outf=file("M1-errors.13gd4r", "wb")
  writeBin(as.vector(errs1), outf, size=4, endian="big")
close(outf)
outf=file("M2-errors.13gd4r", "wb")
  writeBin(as.vector(errs2), outf, size=4, endian="big")
close(outf)
outf=file("M3-errors.13gd4r", "wb")
  writeBin(as.vector(errs3), outf, size=4, endian="big")
close(outf)
outf=file("M4-errors.13gd4r", "wb")
  writeBin(as.vector(errs4), outf, size=4, endian="big")
close(outf)
outf=file("M5-errors.13gd4r", "wb")
  writeBin(as.vector(errs5), outf, size=4, endian="big")
close(outf)

plot_err(lon, lat, errs1*100, "M1")
plot_err(lon, lat, errs2*100, "M2")
plot_err(lon, lat, errs3*100, "M3")
plot_err(lon, lat, errs4*100, "M4")
plot_err(lon, lat, errs5*100, "M5")

# print the numbers

cat("\n  Table X: Comparison of Five Prediction Methods\n") 
cat("====================================================================\n") 
cat("     |  10V     10H     19V     19H     37V     37H     89V     89H\n")
cat("--------------------------------------------------------------------\n") 
errs=errs1
cat(paste("M1:  |", 
            round(mean(errs[ , , 1]*100), 2),
            round(mean(errs[ , , 2]*100), 2),
            round(mean(errs[ , , 3]*100), 2),
            round(mean(errs[ , , 4]*100), 2),
            round(mean(errs[ , , 6]*100), 2),
            round(mean(errs[ , , 7]*100), 2),
            round(mean(errs[ , , 8]*100), 2),
            round(mean(errs[ , , 9]*100), 2), "\n", sep='\t' ) ) 
errs=errs2
cat(paste("M2:  |", 
            round(mean(errs[ , , 1]*100), 2),
            round(mean(errs[ , , 2]*100), 2),
            round(mean(errs[ , , 3]*100), 2),
            round(mean(errs[ , , 4]*100), 2),
            round(mean(errs[ , , 6]*100), 2),
            round(mean(errs[ , , 7]*100), 2),
            round(mean(errs[ , , 8]*100), 2),
            round(mean(errs[ , , 9]*100), 2), "\n", sep='\t' ) ) 
errs=errs3
cat(paste("M3:  |", 
            round(mean(errs[ , , 1]*100), 2),
            round(mean(errs[ , , 2]*100), 2),
            round(mean(errs[ , , 3]*100), 2),
            round(mean(errs[ , , 4]*100), 2),
            round(mean(errs[ , , 6]*100), 2),
            round(mean(errs[ , , 7]*100), 2),
            round(mean(errs[ , , 8]*100), 2),
            round(mean(errs[ , , 9]*100), 2), "\n", sep='\t' ) ) 
errs=errs4
cat(paste("M4:  |", 
            round(mean(errs[ , , 1]*100), 2),
            round(mean(errs[ , , 2]*100), 2),
            round(mean(errs[ , , 3]*100), 2),
            round(mean(errs[ , , 4]*100), 2),
            round(mean(errs[ , , 6]*100), 2),
            round(mean(errs[ , , 7]*100), 2),
            round(mean(errs[ , , 8]*100), 2),
            round(mean(errs[ , , 9]*100), 2), "\n", sep='\t' ) ) 
errs=errs5
cat(paste("M5:  |", 
            round(mean(errs[ , , 1]*100), 2),
            round(mean(errs[ , , 2]*100), 2),
            round(mean(errs[ , , 3]*100), 2),
            round(mean(errs[ , , 4]*100), 2),
            round(mean(errs[ , , 6]*100), 2),
            round(mean(errs[ , , 7]*100), 2),
            round(mean(errs[ , , 8]*100), 2),
            round(mean(errs[ , , 9]*100), 2), "\n", sep='\t' ) ) 

cat("====================================================================\n") 
cat("method 1: single channel MPDI: 10G  and its square (2-predictor)\n")
cat("method 2: five-channel MPDI: 10~89G, linear terms only (4-predictor) \n")
cat("method 3: 9-channel Tbs: 10~89G, linear terms only (9-predictor) \n")
cat("method 4: 9-channel Tb and 4-channel MPDI, linear terms only (13-predictor) \n")
cat("method 5: 9-channel Tb, 9-channel Tb^2, and 4-channel MPDI (22-predictor) \n")


