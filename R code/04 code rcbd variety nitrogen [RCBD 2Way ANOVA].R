rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
rcbd2 <- read.delim("04 rcbd variety nitrogen.txt")

# Randomized Complete Block Design
# Two-Way ANOVA

rcbd2$Variety    <- as.factor(rcbd2f$Variety)
rcbd2$Fertilizer <- as.factor(rcbd2f$Fertilizer)
rcbd2$Block      <- as.factor(rcbd2f$Block)

# plot for first impression
plot(y=rcbd2$Yield, x=rcbd2$Variety)
plot(y=rcbd2$Yield, x=rcbd2$Fertilizer)
plot(y=rcbd2$Yield, x=rcbd2$Block)
boxplot(data=rcbd2, Yield ~ Variety + Fertilizer, las=2)

# Fit general linear model 
###########################
# Treatment effects: Variety, Fertilizer and their interaction
# Design effects:    Block
# Step 1: Check F-Test of ANOVA and perform backwards elimination
# Step 2: Compare adjusted means per level
mod <- lm(data    = rcbd2,
          formula = Yield ~ Variety + Fertilizer +
                            Variety:Fertilizer + Block)

anova(mod) # Interaction is not significant
mod2 <- update(mod, . ~ . -Variety:Fertilizer) # eliminate from model

anova(mod2) # Fertilizer is not significant
mod3 <- update(mod2, . ~ . -Fertilizer) # eliminate from model

anova(mod3) # Variety is significant - Final model found!
library(ggfortify)
autoplot(mod3) # Residual plots
mod3           # Basic results
summary(mod3)  # More detailed results

# get adj. means for Variety effect and compare
#install.packages("multcompView")
#install.packages("emmeans")
library(emmeans) # also needs package multcompView to be installed

# get means and comparisons
means  <- emmeans(mod, pairwise ~ Variety, adjust = "tukey") # to get t-test: adjust="none"
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
