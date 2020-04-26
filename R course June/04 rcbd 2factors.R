rm(list=ls())
setwd("//AFS/uni-hohenheim.de/hhome/p/paulschm/MY-DATA/Desktop/R June")
dt <- read.delim("04 rcbd cultivar nitrogen.txt")

dt$Block <- as.factor(dt$Block)

# first feeling for the data
boxplot(data=dt, Yield ~ Variety + Fertilizer)

# full model
mod <- lm(data    = dt,
          formula = Yield ~ Variety + Fertilizer + 
                            Variety:Fertilizer + Block)

anova(mod) # Variety:Fertilizer is n.s. - drop from model

# reduced model 1
mod2 <- update(mod, . ~ . -Variety:Fertilizer) #reduce mod to mod2
anova(mod2) # Fertilizer is n.s. - drop from model

# final model
mod3 <- update(mod2, . ~ . -Fertilizer) #reduce mod2 to mod3
anova(mod3) # p-Value from F-test for Variety effect  = 0.001729

plot(mod3)

# pairwise mean comparisons
library(emmeans)
means <- lsmeans(mod, "Variety")
means

output <- cld(means, details=T, Letters = "abcd")$emmeans
output








