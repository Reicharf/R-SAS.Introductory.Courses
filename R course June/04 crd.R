rm(list=ls())
setwd("//AFS/uni-hohenheim.de/hhome/p/paulschm/MY-DATA/Desktop/R June")
dt <- read.delim("04 crd cultivar.txt")

dt$Replicate <- as.factor(dt$Replicate)

# first feeling for the data via plot
plot(y=dt$Yield, x=dt$Variety)

# model
mod <- lm(data    = dt,
          formula = Yield ~ Variety)
mod

# ANOVA F-test
anova(mod)     # p-Value from F-test for Variety effect = 0.022

library(emmeans)
means <- lsmeans(mod, "Variety")
means

output <- cld(means, details=T, Letters = "abcd")$emmeans
output

#############################################################
# draw lsmeans graph in ggplot
library(ggplot2)
ggplot(data=output, aes(x=Variety)) +
  geom_bar(aes(y=lsmean), stat="identity", width=0.8) + 
  geom_errorbar(aes(ymin=lsmean-SE, ymax=lsmean+SE), width=0.4) +
  geom_text(aes(y=lsmean+15, label=.group))






