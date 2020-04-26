rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")

library(data.table)
dt <- fread("05 Rice.txt") # directly import as data.table format

# splot plot design - two factor effects

### Split Plot Design 
# When some factors (independent variables) are difficult 
# or impossible to change in your experiment, a completely 
# randomized design isn't possible. The result is a 
# split-plot design, which has a mixture of hard to
# randomize (or hard-to-change) and easy-to-randomize 
# (or easy-to-change) factors. The hard-to-change factors 
# are implemented first, followed by the easier-to-change factors.

dt$Block <- as.factor(dt$Block)
dt$N     <- as.factor(dt$N)
dt$Var   <- as.factor(dt$Var)
dt$Yield <- as.numeric(dt$Yield)

table(dt$Var, dt$N, dt$Block)

# boxplots for first impression
boxplot(data=dt, Yield ~ N + Var, las=2)
boxplot(data=dt, Yield ~ N      , las=2)
boxplot(data=dt, Yield ~ Var    , las=2)

# In a split-plot design, the (incomplete) mainplots should
# be taken as a "random effect". Since we then have random and
# fixed effects in one model, we are fitting a "mixed model".
# In R the most common packages for that are "lme4", "nlme",
# "asreml-R" and "sommer".

# If you use lme4, always load the lmerTest package, too
library(lme4)
library(lmerTest)

# build the mixed model
mod <- lmer(data    = dt,
            formula = Yield ~ N + Var + N:Var + 
                      Block + (1|Block:N))

anova(mod) # interaction effect significant!

# get adj. means for interaction effect and compare
library(emmeans) # also needs package multcompView to be installed

# get means and comparisons
means <- emmeans(mod, pairwise ~ N | Var) 
   # Note that N | Var gets pairwise N comparisons for each
   # Variety separately. You can use N*Var instead to get all
   # pairwise comparisons.

means # look at means and comparisons
means$emmeans   # look at means
means$contrasts # look at comparions

output <- cld(means$emmeans, details=T, Letters = letters)
output # this data format is not good for ggplot
output <- as.data.table(output$emmeans) # reformatting into one table
output # this is better

###########################################################
# draw lsmeans graph in ggplot
library(ggplot2)
p <- ggplot(data=output, aes(x=N))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8) 
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+1500, label=.group))
p <- p + facet_wrap(~Var) # one per variety

p # show plot

# save ggplot as file into your working directory
ggsave("test.jpeg", width = 20, height = 10, units = "cm")
