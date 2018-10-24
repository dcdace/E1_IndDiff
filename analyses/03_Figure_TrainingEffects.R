library(ggplot2)
library(Hmisc)
library(gridExtra)

# import the data
E1data <- read.csv("E1cleaned.csv")

# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================

# Sequence-specific learning
E1data$ETPreDiff  <- E1data$ETPreUN / E1data$ETPreTR - 1
E1data$ETPostDiff <- E1data$ETPostUN / E1data$ETPostTR - 1

ssLearning <- (E1data$ETPostDiff - E1data$ETPreDiff) * 100

# General skill learning
gsLearning <- (E1data$ETPreUN / E1data$ETPostUN - 1) * 100

# OO and OA groups
group <- as.factor(E1data$group)

minV <- round(min(c(min(ssLearning), min(gsLearning))))
maxV <- round(max(c(max(ssLearning), max(gsLearning))))

# ==================================================================
# PLOT THE RESULTS
# ==================================================================

plotResults <- function(x, txt) {
  ggplot(E1data, aes(group, x)) +
    stat_summary(
      fun.data = mean_cl_boot,
      geom = "pointrange",
      aes(fill = group),
      alpha = 0.7,
      color = "black",
      size = 1.5,
      stroke = 2,
      shape = 21,
      position = position_nudge(x = -0.2)
    ) +
    
    scale_y_continuous(limits = c(minV, maxV),
                       breaks = seq(-100, 200, 50)) +
    geom_hline(aes(yintercept = 0)) +
    
    scale_x_discrete(
      breaks = c("OA", "PP"),
      labels = c("Observational\npractice", "Physical\npractice")
    ) +
    
    geom_point(
      alpha = 0.7,
      size = 3,
      stroke = 1,
      shape = 21,
      aes(fill = group),
      position = position_jitter(height = 0, width = 0.1)
    ) +
    
    scale_fill_manual(values = c('#999999', '#E69F00')) +
    labs(x = "", y = txt) +
    theme_minimal() +
    theme(legend.position = "none",
          text = element_text(size = 30))
}

p1 <- plotResults(ssLearning, "Sequence-specific learning (%)")
p2 <- plotResults(gsLearning, "General skill learning (%)")

grid.arrange(p1, p2, nrow = 1)
