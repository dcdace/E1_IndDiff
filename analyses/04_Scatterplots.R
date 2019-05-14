library(Hmisc)
library(ggpubr)
library(ggplot2)
library(gridExtra)
library(ggExtra)
library(cowplot)

# import the data
E1data = read.csv("E1cleaned.csv")
# ==================================================================
# CALCULATE NECCESSARY VARIABLES
# ==================================================================

# Baseline perfornance
E1data$ETPre  <- 1 - ((E1data$ETPreTR + E1data$ETPreUN) / 2)

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

#xvar <- E1data$ETppDiff * 100
xvar <- gsLearning
#yvar <- E1data$IQsum
yvar <- E1data$WM
#yvar <- E1data$ETPre

xy <- data.frame(xvar, yvar, group)

#scatterplot of x and y variables
scatter <- ggplot(xy, aes(xvar, yvar)) +
  geom_point(
    aes(fill = group),
    color = "black",
    size = 4,
    stroke = 1.5,
    shape = 21,
    alpha = 0.7
  ) +
  scale_fill_manual(
    values = c('#999999', '#E69F00'),
    name = "",
    breaks = c("OA", "PP"),
    labels = c("Observational practice", "Physical practice")
  ) +
  scale_color_manual(values = c('#999999', '#E69F00')) +
  
  geom_line(stat="smooth", method = lm, aes(color = group), se = FALSE, fullrange = TRUE, size = 3, alpha = 0.8,show.legend = F) + 
  

  #labs(x = "Sequence-specific learning (%)", y = "Fluid intelligence") +
  #labs(x = "General skill learning (%)", y = "Fluid intelligence") +
  
  #labs(x = "Sequence-specific learning (%)", y = "Working memory") +
  #labs(x = "General skill learning (%)", y = "Working memory") +
  
  #labs(x = "Sequence-specific learning (%)", y = "Baseline performance") +
  labs(x = "General skill learning (%)", y = "Baseline perfoemance") +
  theme_minimal() +
  theme(
    #legend.position = c(0, 1),
    legend.position = "none",
    legend.justification = c(0, 1),
    legend.title=element_blank(),
    text = element_text(size = 30)
  )

# Marginal densities along x axis
xdens <- axis_canvas(scatter, axis = "x") +
  geom_density(
    data = xy,
    aes(x = xvar, fill = group),
    alpha = 0.7,
    size = 1
  ) +
  scale_fill_manual(values = c('#999999', '#E69F00'))

# Marginal densities along y axis
# Need to set coord_flip = TRUE, if you plan to use coord_flip()
ydens <- axis_canvas(scatter, axis = "y", coord_flip = TRUE) +
  geom_density(
    data = xy,
    aes(x = yvar, fill = group),
    alpha = 0.7,
    size = 1
  ) +
  coord_flip() +
  scale_fill_manual(values = c('#999999', '#E69F00'))


p1 <-
  insert_xaxis_grob(scatter, xdens, grid::unit(.2, "null"), position = "top")
p2 <-
  insert_yaxis_grob(p1, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(p2)

