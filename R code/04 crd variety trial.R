rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
crd <- read.delim("04 crd variety.txt")

# Completely randomized design - one factor effect

crd$Variety  <- as.factor(crd$Variety)
crd$Replicate <- as.factor(crd$Replicate)

# plot for first impression
plot(y=crd$Yield, x=crd$Variety)

# linear model with Variety as factor effect
mod <- lm(data    = crd,
          formula = Yield ~ Variety)

mod
summary(mod)
anova(mod) # Variety effect is significant ANOVA

# get adj. means for Variety effect and compare
library(emmeans) # also needs package multcompView to be installed

# get means and comparisons
means  <- emmeans(mod, pairwise ~ Variety)
means # look at means and comparisons
means$emmeans   # look at means
means$contrasts # look at comparions

# add letters indicating significant differences
output <- cld(means$emmeans, details=T, Letters = letters)

# plot results
library(ggplot2)
p <- ggplot(data=output$emmeans, aes(x=Variety))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8)
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+15, label=.group))

p # show plot