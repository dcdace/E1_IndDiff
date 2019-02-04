library(lavaan)
library(semPlot)

# import the data
E1data <- read.csv("E1cleaned.csv")
OAdatacleaned <- read.csv("OAcleaned.csv")
# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================
# Baseline performance
E1data$ITPre  <- (E1data$ITPreTR + E1data$ITPreUN) / 2
E1data$bPerf  <- 1-((E1data$ETPreTR + E1data$ETPreUN) / 2)
E1data$ErrPre <- (E1data$ErrPreTR + E1data$ErrPreUN) / 2
# UN TR difference
E1data$ITPreDiff    <- E1data$ITPreUN / E1data$ITPreTR - 1
E1data$ITPostDiff   <- E1data$ITPostUN / E1data$ITPostTR - 1
E1data$ETPreDiff    <- E1data$ETPreUN / E1data$ETPreTR - 1
E1data$ETPostDiff   <- E1data$ETPostUN / E1data$ETPostTR - 1
E1data$ErrPreDiff   <- E1data$ErrPreUN - E1data$ErrPreTR
E1data$ErrPostDiff  <- E1data$ErrPostUN - E1data$ErrPostTR

# IT 
E1data$IT_TRpp <- (E1data$ITPreTR / E1data$ITPostTR - 1) * 100
E1data$IT_UNpp <- (E1data$ITPreUN / E1data$ITPostUN - 1) * 100
# ET
E1data$ET_TRpp <- (E1data$ETPreTR / E1data$ETPostTR - 1) * 100
E1data$ET_UNpp <- (E1data$ETPreUN / E1data$ETPostUN - 1) * 100
# ER
E1data$Err_TRpp <- E1data$ErrPreTR - E1data$ErrPostTR
E1data$Err_UNpp <- E1data$ErrPreUN - E1data$ErrPostUN
# PostDiff-PreDiff
E1data$ETppDiff <- E1data$ETPostDiff - E1data$ETPreDiff
# ==================================================================
# SEPARATE PP AND OA GROUPS AND SCALE WITHIN EACH GROUP
# ==================================================================
# z-scores the data: calculate the mean and standard deviation of the entire vector, 
# then "scale" each element by those values by subtracting the mean and dividing by the sd.
# It removes the unit of measurement and variance of all variables is 1. 
# scale(x, scale=FALSE) will only subtract the mean but not divide by the std deviation.)
PPdata <- E1data[E1data$group == "PP",]
OAdata <- E1data[E1data$group == "OA",]
OAdata$Acc <- (OAdatacleaned$run1Acc+OAdatacleaned$run2Acc+OAdatacleaned$run3Acc+OAdatacleaned$run4Acc)/4

PPdata[,8:ncol(PPdata)] <- scale(PPdata[,8:ncol(PPdata)])
OAdata[,8:ncol(OAdata)] <- scale(OAdata[,8:ncol(OAdata)])
# ==================================================================
# REGRESSION SUBSET SELECTION
# identify best nvmax variables
# ==================================================================
require(leaps)
require(car)

# find models for
# PP
PPUNpp <- regsubsets(
  ET_UNpp ~ bPerf + IQsum + WM + Extrov + Agr + Consc + Neur + Open + PT + FS + EC + PD + NPI + InterD,
  data = PPdata,
  nvmax = 14,
  nbest = 2,
  force.in = 1
)
PPppDiff <- regsubsets(
  ETppDiff ~ bPerf + IQsum + WM + Extrov + Agr + Consc + Neur + Open + PT + FS + EC + PD + NPI + InterD,
  data = PPdata,
  nvmax = 14,
  nbest = 2,
  force.in = 1
)
# OA
OAUNpp <- regsubsets(
  ET_UNpp ~ bPerf + IQsum + WM + Extrov + Agr + Consc + Neur + Open + PT + FS + EC + PD + NPI + InterD,
  data = OAdata,
  nvmax = 14,
  nbest = 2,
  force.in = 1
)
OAppDiff <- regsubsets(
  ETppDiff ~ bPerf + IQsum + WM + Extrov + Agr + Consc + Neur + Open + PT + FS + EC + PD + NPI + InterD,
  data = OAdata,
  nvmax = 14,
  nbest = 2
)


par(mfrow=c(1,2), cex=2, cex.lab = 1.5)
ssPP<- plot(PPppDiff, scale="bic")
ssOP<- plot(OAppDiff, scale="bic")

par(mfrow=c(1,2), cex=2, cex.lab = 1.5)

gsPP<- plot(PPUNpp, scale="bic")
gsOP<- plot(OAUNpp, scale="bic")




