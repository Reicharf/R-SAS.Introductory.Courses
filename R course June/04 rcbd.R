rm(list=ls())
setwd("//AFS/uni-hohenheim.de/hhome/p/paulschm/MY-DATA/Desktop/R June")
dt <- read.delim("04 rcbd cultivar.txt")

dt$Block <- as.factor(dt$Block)

# model
mod <- lm(data    = dt,
          formula = Yield ~ Variety + Block)
mod

# anova
anova(mod) # p-Value from F-test for Variety effect  = 0.01109

# pairwise mean comparisons
library(emmeans)
means <- lsmeans(mod, "Variety")
means

output <- cld(means, details=T, Letters = "abcd")$emmeans
output

