library(lavaan)
library(semPlot)

OAdata <- read.csv("OAcleaned.csv")

# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================

# mean Accuracy
OAdata$meanAcc <-  rowMeans(subset(OAdata, select
                                   = c(run1Acc, run2Acc, run3Acc, run4Acc)))

OAdata$accImprovement <-  OAdata$run4Acc - OAdata$run2Acc

# scale
OAdata[, 8:ncol(OAdata)] <-  scale(OAdata[, 8:ncol(OAdata)])
# ==================================================================
# SET AND ESTIMATE THE MODELS
# ==================================================================

# OA
model.OA <-  'accImprovement ~ run2Acc + IQsum + WM'
fitOA    <-  sem(model.OA, data = OAdata)
# ==================================================================
# DISPLAY RESULTS
# ==================================================================
#define the label that will go into the nodes
lbls <-  c(
  "Run2 to Run4\naccuracy\nimprovement",
  "Run2\naccuracy",
  "Fluid\nintelligence",
  "Working\nmemory"
)
# colour groups
grps <-
  list(
    cov = "run2Acc",
    exog = c("IQsum", "WM"),
    endogGen = c("accImprovement")
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
    color = c("light blue",
              "light blue",
              "light green"),
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
    # edge.label.position = c(
    #   0.5, 0.3, 0.8, 0.3, 0.7, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5
    # ),
    asize = 5,
    border.width = 3,
    mar = c(7, 7, 7, 7),
    colFactor = 0.8
  )

graphOA <-  show(fitOA)

# OA
summary(lm(accImprovement ~ run2Acc + IQsum + WM, data = OAdata))
