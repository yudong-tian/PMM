
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

lon=seq(-19.875, 59.875, 0.25) 
lat=seq(-34.875, 39.875, 0.25) 
nx=(lon-lon0)/0.25+1
ny=(lat-lat0)/0.25+1

#X is varying   Lon = -19.875 to 59.875   X = 641 to 960
#Y is varying   Lat = -34.875 to 39.875   Y = 221 to 520

nems=13   # how many emissivity channels to predict

errs1=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs2=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs3=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs4=array(-9999.0, dim=c(length(nx), length(ny), nems))
errs5=array(-9999.0, dim=c(length(nx), length(ny), nems))

#save the data in binary file
outf=file("M1-errors.13gd4r", "rb")
  x=readBin(outf, numeric(), n=length(nx)*length(ny)*nems, size=4, endian="big")
  errs1=array(x, c(length(nx), length(ny), nems)) 
close(outf)
outf=file("M2-errors.13gd4r", "rb")
  x=readBin(outf, numeric(), n=length(nx)*length(ny)*nems, size=4, endian="big")
  errs2=array(x, c(length(nx), length(ny), nems)) 
close(outf)
outf=file("M3-errors.13gd4r", "rb")
  x=readBin(outf, numeric(), n=length(nx)*length(ny)*nems, size=4, endian="big")
  errs3=array(x, c(length(nx), length(ny), nems)) 
close(outf)
outf=file("M4-errors.13gd4r", "rb")
  x=readBin(outf, numeric(), n=length(nx)*length(ny)*nems, size=4, endian="big")
  errs4=array(x, c(length(nx), length(ny), nems)) 
close(outf)
outf=file("M5-errors.13gd4r", "rb")
  x=readBin(outf, numeric(), n=length(nx)*length(ny)*nems, size=4, endian="big")
  errs5=array(x, c(length(nx), length(ny), nems)) 
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


