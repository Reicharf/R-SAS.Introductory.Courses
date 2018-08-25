rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
rcbd <- read.delim("04 rcbd variety.txt")

# randomized complete block design - one factor effect

rcbd$Variety <- as.factor(rcbd$Variety)
rcbd$Block   <- as.factor(rcbd$Block)

plot(y=rcbd$Yield, x=rcbd$Variety)
plot(y=rcbd$Yield, x=rcbd$Block)
boxplot(data=rcbd, Yield ~ Variety + Block, las=2)

# linear model with Variety (=Treatment) effect 
# and block (=Design) effect
mod <- lm(data    = rcbd,
          formula = Yield ~ Variety + Block)

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