rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
rcbd <- read.delim("04 rcbd variety.txt")

# Randomized Complete Block Design
# One-Way ANOVA

rcbd$Variety <- as.factor(rcbd$Variety)
rcbd$Block   <- as.factor(rcbd$Block)

# plot for first impression
plot(y=rcbd$Yield, x=rcbd$Variety)
plot(y=rcbd$Yield, x=rcbd$Block)
boxplot(data=rcbd, Yield ~ Variety + Block, las=2)

# Fit general linear model 
###########################
# Treatment effects: Variety
# Design effects:    Block
# Step 1: Check F-Test of ANOVA
# Step 2: Compare adjusted means per level
mod <- lm(data    = rcbd,
          formula = Yield ~ Variety + Block)

library(ggfortify)
autoplot(mod) # Residual plots
mod           # Basic results
summary(mod)  # More detailed results
anova(mod)    # ANOVA-table: Variety effect is significant

# get adj. means for Variety effect and compare
#install.packages("multcompView")
#install.packages("emmeans")
library(emmeans) # also needs package multcompView to be installed

# get means and comparisons
means  <- emmeans(mod, pairwise ~ Variety)
means # look at means and comparisons
means$emmeans   # look at means
means$contrasts # look at comparions

# add letters indicating significant differences
output <- cld(means$emmeans, details=T, Letters = letters)

# plot adjusted means

#install.packages("ggplot2")
library(ggplot2)
p <- ggplot(data=output$emmeans, aes(x=Variety))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8)
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+15, label=.group))

p # show plot
