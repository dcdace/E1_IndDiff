library(psych)

# import PP and OA data
OAdata <- read.csv(file = "OA_raw.csv", header = T)
PPdata <- read.csv(file = "PP_raw.csv", header = T)
# ==================================================================
# ORIGINAL SAMPLE SIZE
# ==================================================================
# original cases N
casesOA <- dim(OAdata)[1]
casesPP <- dim(PPdata)[1]

origN         <- casesOA + casesPP
bindGenderAge <- rbind(OAdata[,c(2:4)], PPdata[,c(2:4)])
origGender    <- table(bindGenderAge$gender)
origAge       <- describe(bindGenderAge$age)
originalTXT <- sprintf(
  "N <- %d (%d males and %d females), %d to %d years old (M = %.2f years, SD = %.2f).",
  origN,
  origGender[2],
  origGender[1],
  origAge$min,
  origAge$max,
  origAge$mean,
  origAge$sd
)
# ==================================================================
# WHAT AND HOW MANY WILL BE EXCLUDED
# ==================================================================

# NaNs
NaNs <- (dim(OAdata)[1] - dim(na.omit(OAdata))[1]) + (dim(PPdata)[1] - dim(na.omit(PPdata))[1])

# Left-handed
lefts <- length(which(OAdata$righthanded != "Yes")) + length(which(PPdata$righthanded != "Yes"))

# OA group, > 50% errors in days2-4
exclErr <- 50
inAccurate <- dim(OAdata)[1] - length(which(
  OAdata$run2Acc > exclErr &
    OAdata$run3Acc > exclErr & OAdata$run4Acc > exclErr
))

# ==================================================================
# EXCLUDE
# ==================================================================

# Exclude participants who did not execute correctly even a single sequence in any condition (NaNs)
OAdata <- na.omit(OAdata)
PPdata <- na.omit(PPdata)

# Exclude left handed participants
OAdata <- OAdata[which(OAdata$righthanded == "Yes"), ]
PPdata <- PPdata[which(PPdata$righthanded == "Yes"), ]

# Exclude from OA if on days2-4 watching errors > 50%
OAdata <- OAdata[which(OAdata$run2Acc > exclErr & OAdata$run3Acc > exclErr & OAdata$run4Acc > exclErr),]

# ==================================================================
# FROM THE REMAINING EXCLUDE PRE-TEST ET OUTLIERS
# ==================================================================

# Exclude pre-test outliers
var <- c("ETPreTR",
        "ETPreUN")

# change outlier values to NaN
PPdata[, var] <- lapply(var, function(x)
  ifelse(PPdata[, x] %in% boxplot.stats(PPdata[, x], coef = 2)$out, NA, PPdata[, x]))

OAdata[, var] <- lapply(var, function(x)
  ifelse(OAdata[, x] %in% boxplot.stats(OAdata[, x], coef = 2)$out, NA, OAdata[, x]))

# exclude the selected NaNs
outlierNaNs <- (dim(OAdata)[1] - dim(na.omit(OAdata))[1]) + (dim(PPdata)[1] - dim(na.omit(PPdata))[1])
OAdata <- na.omit(OAdata)
PPdata <- na.omit(PPdata)

# ==================================================================
# PREPARE OUTPUT
# ==================================================================

badCases <- sprintf(
  "NaNs: %d, Lefts: %d, OA Inaccurate: %d, Outliers: %d",
  NaNs,
  lefts,
  inAccurate,
  outlierNaNs
)
# Total N removed
remOA <- casesOA - dim(OAdata)[1]
remPP <- casesPP - dim(PPdata)[1]
totalRemovedTxt <- sprintf(
  "OA removed: %d from %d (%.0f%%), PP removed: %d from %d (%.0f%%)",
  remOA,
  casesOA,
  remOA / casesOA * 100,
  remPP,
  casesPP,
  remPP / casesPP * 100
)

# ==================================================================
# PUT OA AND PP IN ONE TABLE
# ==================================================================

# bind both groups excluding training results
E1data <- rbind(OAdata[,-c(7:10)], PPdata[,-c(7:18)])

# ==================================================================
# OUTPUT
# ==================================================================

print(list(originalTXT, badCases, totalRemovedTxt))

write.csv(E1data, file = "E1cleaned.csv")
write.csv(OAdata, file = "OAcleaned.csv")
write.csv(PPdata, file = "PPcleaned.csv")
