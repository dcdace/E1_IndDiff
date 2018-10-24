library(lavaan)
library(semPlot)

# import the data
E1data <- read.csv("D:/_CogNeurPhD/01-Experiment/E1cleaned.csv")
# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================
# Baseline performance
E1data$ITPre  <- (E1data$ITPreTR + E1data$ITPreUN) / 2
E1data$ETPre  <- 1 - ((E1data$ETPreTR + E1data$ETPreUN) / 2)
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

E1data$ETPost  <- 1 - ((E1data$ETPostTR + E1data$ETPostUN) / 2)
# ==================================================================
# SEPARATE PP AND OA GROUPS AND SCALE WITHIN EACH GROUP
# ==================================================================
# z-scores the data: calculate the mean and standard deviation of the entire vector,
# then "scale" each element by those values by subtracting the mean and dividing by the sd.
# It removes the unit of measurement and variance of all variables is 1.
# scale(x, scale=FALSE) will only subtract the mean but not divide by the std deviation.)
PPdata <- E1data[E1data$group == "PP", ]
OAdata <- E1data[E1data$group == "OA", ]

PPdata[, 8:ncol(PPdata)] <- scale(PPdata[, 8:ncol(PPdata)])
OAdata[, 8:ncol(OAdata)] <- scale(OAdata[, 8:ncol(OAdata)])
# ==================================================================
# SET AND ESTIMATE THE MODELS
# ==================================================================
# PP
model.PP <- 'ET_UNpp ~ ETPre + IQsum + WM
ETppDiff ~ ETPre + IQsum + WM'
fitPP <- sem(model.PP, data = PPdata)
# OA
model.OA <- 'ET_UNpp ~ ETPre + IQsum + WM
ETppDiff ~ ETPre + IQsum + WM'
fitOA <- sem(model.OA, data = OAdata)
# ==================================================================
# DISPLAY RESULTS
# ==================================================================
#define the label that will go into the nodes
lbls <- c(
  "General-\nskill\nlearning",
  "Sequence-\nspecific\nlearning",
  "Baseline\nperformance",
  "Fluid\nintelligence",
  "Working\nmemory"
)
# colour groups
grps <-
  list(
    cov = "ETPre",
    exog = c("IQsum", "WM"),
    endogGen = c("ET_UNpp"),
    endogSS = "ETppDiff"
  )

# show
show <- function(fit)
  semPaths(
    fit,
    "std",
    "estimates",
    layout = "tree2",
    nCharNodes = 0,
    nCharEdges = 0,
    sizeMan = 17,
    label.cex = 2,
    label.scale = FALSE,
    nodeLabels = lbls,
    edge.label.cex = 2.5,
    edge.width = .7,
    groups = grps,
    color = c(
      "light blue",
      "light blue",
      rgb(245, 253, 118, maxColorValue = 255),
      "orange"
    ),
    legend = FALSE,
    residuals = FALSE,
    curvePivot = TRUE,
    curve = 1,
    cardinal = TRUE,
    curveAdjacent = TRUE,
    bg = "white",
    optimizeLatRes = TRUE,
    nDigits = 2,
    normalize = TRUE,
    negCol = "red",
    curvePivot = TRUE,
    curvePivotShape = 0.5,
    edge.label.position = c(0.5, 0.3, 0.8, 0.3, 0.7, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
    asize = 5,
    border.width = 3,
    mar = c(7, 7, 7, 7),
    colFactor = 0.8
  )

# put PP and OA on one graph
layout(t(1:2))
graphPP <- show(fitPP)
graphOA <- show(fitOA)

# ==================================================================
# REGRESSION RESULTS
# ==================================================================
# Sequence-specific
# PP
summary(lm(ETppDiff ~ ETPre + IQsum + WM, data = PPdata))
# OA
summary(lm(ETppDiff ~ ETPre + IQsum + WM, data = OAdata))

# General skill
# PP
summary(lm(ET_UNpp ~ ETPre + IQsum + WM, data = PPdata))
# OA
summary(lm(ET_UNpp ~ ETPre + IQsum + WM, data = OAdata))
