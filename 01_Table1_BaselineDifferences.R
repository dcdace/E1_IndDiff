library(xtable) # for html formatted table

E1data <- read.csv("E1cleaned.csv")
# ==================================================================
# group sample sizes
PPN <- table(E1data$group)["PP"]
OAN <- table(E1data$group)["OA"]

# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================
# Baseline performance
E1data$ITPre  <- (E1data$ITPreTR + E1data$ITPreUN) / 2
E1data$ETPre  <- (E1data$ETPreTR + E1data$ETPreUN) / 2
E1data$ErrPre <- (E1data$ErrPreTR + E1data$ErrPreUN) / 2

# ==================================================================
# GENDER PROPORTION
# ==================================================================
genderCount <- table(E1data$group, E1data$gender)

genderDiffpval <- chisq.test(E1data$group, E1data$gender)$p.value

resultsGender <- matrix(
  c(
    paste(genderCount["PP", 2], ":", genderCount["PP", 1], sep = ""),
    paste(genderCount["OA", 2], ":", genderCount["OA", 1], sep = ""),
    round(genderDiffpval, 3)
  ),
  nrow = 1,
  ncol = 3,
  dimnames = list("gender male:female", c(
    paste("PP (N =", PPN, ")"),
    paste("OA (N =", OAN, ")"),
    "Difference p-val"
  ))
)
# ==================================================================
# ENGLISH 1ST LANGUAGE PROPORTION
# ==================================================================
englishCount <- table(E1data$group, E1data$english)

englishDiffpval <- chisq.test(E1data$group, E1data$english)$p.value

resultsEnglish <- matrix(
  c(
    paste(englishCount["PP", 2], ":", englishCount["PP", 1], sep = ""),
    paste(englishCount["OA", 2], ":", englishCount["OA", 1], sep = ""),
    round(englishDiffpval, 3)
  ),
  nrow = 1,
  ncol = 3,
  dimnames = list("English 1st yes:no", c(
    paste("PP (N =", PPN, ")"),
    paste("OA (N =", OAN, ")"),
    "Difference p-val"
  ))
)
# ==================================================================
# AGE and BASELINE PERFORMANCE
# ==================================================================
scoresPar   <- c("age", "ITPre", "ETPre", "ErrPre", "WM", "IQsum")
# means
meansPP <- lapply(scoresPar, function(x)
  mean(subset(E1data[, x], E1data$group == "PP")))
meansOA <- lapply(scoresPar, function(x)
  mean(subset(E1data[, x], E1data$group == "OA")))
sdPP <- lapply(scoresPar, function(x)
  sd(subset(E1data[, x], E1data$group == "PP")))
sdOA <- lapply(scoresPar, function(x)
  sd(subset(E1data[, x], E1data$group == "OA")))

baselineDiffpval <- lapply(scoresPar, function(x)
  t.test(E1data[, x] ~ group,
         data = E1data,
         alternative = "two.sided")$p.value)

baselineDiffpvalTxt <- lapply(baselineDiffpval, function(x)
  ifelse(x < 0.001, "< 0.001", round(x, 3)))

resultsPar <- matrix(
  c(
    paste(
      lapply(meansPP, function(x)
        round(x, 2)),
      "+-",
      lapply(sdPP, function(x)
        round(x, 2))
    ),
    paste(
      lapply(meansOA, function(x)
        round(x, 2)),
      "+-",
      lapply(sdOA, function(x)
        round(x, 2))
    ),
    baselineDiffpvalTxt
  ),
  nrow = length(scoresPar),
  ncol = 3,
  dimnames = list(scoresPar, c(
    paste("PP (N =", PPN, ")"),
    paste("OA (N =", OAN, ")"),
    "Difference p-val"
  ))
)
################
scoresNonp   <-
  c("Extrov",
    "Agr",
    "Consc",
    "Neur",
    "Open",
    "PT",
    "FS",
    "EC",
    "PD",
    "NPI",
    "InterD")

# means
meansPP <- lapply(scoresNonp, function(x)
  mean(subset(E1data[, x], E1data$group == "PP")))

meansOA <- lapply(scoresNonp, function(x)
  mean(subset(E1data[, x], E1data$group == "OA")))

sdPP <- lapply(scoresNonp, function(x)
  sd(subset(E1data[, x], E1data$group == "PP")))

sdOA <- lapply(scoresNonp, function(x)
  sd(subset(E1data[, x], E1data$group == "OA")))

baselineDiffpval <- lapply(scoresNonp, function(x)
  wilcox.test(E1data[, x] ~ group,
              data = E1data,
              alternative = "two.sided")$p.value)

baselineDiffpvalTxt <- lapply(baselineDiffpval, function(x)
  ifelse(x < 0.001, "< 0.001", round(x, 3)))

resultsNonp <- matrix(
  c(
    paste(
      lapply(meansPP, function(x)
        round(x, 2)),
      "+-",
      lapply(sdPP, function(x)
        round(x, 2))
    ),
    paste(
      lapply(meansOA, function(x)
        round(x, 2)),
      "+-",
      lapply(sdOA, function(x)
        round(x, 2))
    ),
    baselineDiffpvalTxt
  ),
  nrow = length(scoresNonp),
  ncol = 3,
  dimnames = list(scoresNonp, c(
    paste("PP (N =", PPN, ")"),
    paste("OA (N =", OAN, ")"),
    "Difference p-val"
  ))
)
# ==================================================================
# OUTPUT
# ==================================================================
# print(resultsGender)
# print(resultsPar)
# print(resultsNonp)
results <-
  rbind(resultsGender, resultsEnglish, resultsPar, resultsNonp)
print(results)

formattedresults <- print(xtable(results), type = "html")

write.table(formattedresults, file = "baselineDifferences.html")
