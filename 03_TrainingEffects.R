

# import the data
E1data <- read.csv("E1cleaned.csv")

# group sample sizes
PPN <- table(E1data$group)["PP"]
OAN <- table(E1data$group)["OA"]
# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================

# UN TR difference
E1data$ETPreDiff  <- (E1data$ETPreUN / E1data$ETPreTR - 1) * 100
E1data$ETPostDiff <- (E1data$ETPostUN / E1data$ETPostTR - 1) * 100

# PostDiff-PreDiff
E1data$ETppDiff <- E1data$ETPostDiff - E1data$ETPreDiff
# General learning
E1data$ET_UNpp <- (E1data$ETPreUN / E1data$ETPostUN - 1) * 100


# which scores (columns) to process
scoresPost        <- c("ETppDiff",
                       "ET_UNpp")
scoresPost_names  <-c("S-S learning ",
                      "G S learning")

scN <- length(scoresPost) # how many scores

# ==================================================================
# TRAINING EFFECT
# ==================================================================
# One sample t-test for each group
trEffect <- mapply(function(grp, post)
  t.test(E1data[E1data$group == grp, ][, post]),
  c(rep("PP", scN), rep("OA", scN)), scoresPost)

trEffect_mean <- mapply(function(grp, post)
  mean(E1data[E1data$group == grp, ][, post]),
  c(rep("PP", scN), rep("OA", scN)), scoresPost)

trEffect_CI <- mapply(function(grp, post)
  sd(E1data[E1data$group == grp, ][, post]) / sqrt(nrow(data.frame (E1data[E1data$group == grp, ][, post]))) * 1.99,
  c(rep("PP", scN), rep("OA", scN)),
  scoresPost)


trEffect_d <- sapply(1:dim(trEffect)[2], function(x)
  round(trEffect[, x]$parameter, 2))

trEffect_tvals <- sapply(1:dim(trEffect)[2], function(x)
  round(trEffect[, x]$statistic, 2))

trEffect_pvals <- sapply(1:dim(trEffect)[2], function(x)
  round(trEffect[, x]$p.val, 4))


trEffect_pvals <- sapply(1:dim(trEffect)[2], function(x)
  trEffect[, x]$p.val)
trEffect_pvals


trEffect_pvalsTXT <- lapply(trEffect_pvals, function(x)
  ifelse(x < 0.0001, "< 0.0001", paste("=", round(x, 4))))

trEffect_dz <- round(c(trEffect_tvals[1:scN] / sqrt(PPN),
                      trEffect_tvals[(scN + 1):(scN * 2)] / sqrt(OAN)), 2)

# format results as txt strings
resTrainingTXT <- mapply(
  function(m, lCI, uCI, df, t, p, d)
    sprintf(
      "M =  %.0f%% [%.0f%%, %.0f%%], t(%d) = %.2f, p %s, dz = %.2f.",
      m,
      lCI,
      uCI,
      df,
      t,
      p,
      d
    ),
  trEffect_mean,
  trEffect_mean - trEffect_CI,
  trEffect_mean + trEffect_CI,
  trEffect_d,
  trEffect_tvals,
  trEffect_pvalsTXT,
  trEffect_dz
)
# put PP and OA results in separate columns
resTrainingTXT2 <- matrix(
  resTrainingTXT,
  nrow = scN,
  ncol = 2,
  dimnames = list(scoresPost_names, c("PP", "OA"))
)
# ==================================================================
# group EFFECT
# ==================================================================
# t and p
groupDiff <- lapply(scoresPost, function(post)
  t.test(as.formula(paste(post, "~ group")), data = E1data))

mean_diff <- sapply(1:length(groupDiff), function(x)
  groupDiff[[x]]$estimate[2] - groupDiff[[x]]$estimate[1])

lCI <- sapply(1:length(groupDiff), function(x)
  groupDiff[[x]]$conf.int[1])

uCI <- sapply(1:length(groupDiff), function(x)
  groupDiff[[x]]$conf.int[2])

df <- sapply(1:length(groupDiff), function(x)
  groupDiff[[x]]$parameter)
tvals <- sapply(1:length(groupDiff), function(x)
  groupDiff[[x]]$statistic)
pvals <- sapply(1:length(groupDiff), function(x)
  groupDiff[[x]]$p.val)
pvalsTXT <- lapply(pvals, function(x)
  ifelse(x < 0.0001, "< 0.0001", paste("=", round(x, 4))))

ds <- 2 * tvals / sqrt(df)

# format results as txt strings
resTXT <- mapply(
  function(score, m, lCI, uCI, df, t, p, d)
    sprintf(
      "%s: %.0f%% [%.0f%%, %.0f%%], t(%.2f) = %.2f, p %s, d = %.2f.",
      score,
      m,
      lCI,
      uCI,
      df,
      t,
      p,
      d
    ),
  scoresPost_names,
  mean_diff,
  lCI,
  uCI,
  df,
  as.numeric(tvals, 2),
  pvalsTXT,
  abs(ds)
)
# put in matrix
resTXT2 <- matrix(
  resTXT,
  nrow = scN,
  ncol = 1,
  dimnames = list(scoresPost, "group effect (group difference)")
)

results <- cbind(resTrainingTXT2, resTXT2)

print(results)
