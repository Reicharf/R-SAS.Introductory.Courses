rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
rcbd2f <- read.delim("04 rcbd variety nitrogen.txt")

# randomized complete block design - two factor effects

rcbd2f$Variety    <- as.factor(rcbd2f$Variety)
rcbd2f$Fertilizer <- as.factor(rcbd2f$Fertilizer)
rcbd2f$Block      <- as.factor(rcbd2f$Block)

plot(y=rcbd2f$Yield, x=rcbd2f$Variety)
plot(y=rcbd2f$Yield, x=rcbd2f$Fertilizer)
plot(y=rcbd2f$Yield, x=rcbd2f$Block)
boxplot(data=rcbd2f, Yield ~ Variety + Fertilizer, las=2)

# linear model with Var, Fert and their intercation (=Treatment) effects 
# and block (=Design) effect
mod <- lm(data    = rcbd2f,
          formula = Yield ~ Variety + Fertilizer +
                            Variety:Fertilizer + Block)

mod
summary(mod)
anova(mod) # interaction effect is not significant.

mod2 <- update(mod, . ~ . -Variety:Fertilizer) # remove it from model
anova(mod2) # Fertilizer is not significant

mod3 <- update(mod2, . ~ . -Fertilizer) # remove it from model
anova(mod3)# Variety effect is significant ANOVA

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