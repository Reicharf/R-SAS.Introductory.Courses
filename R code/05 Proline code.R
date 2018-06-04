rm(list=ls())
setwd("C:/Users/Paul/Desktop/R course")
dat <- read.delim("05 data Proline.txt")

dat$carb     <- as.factor(dat$carb)
dat$cult     <- as.factor(dat$cult)
dat$wat      <- as.factor(dat$wat)
dat$mainplot <- as.factor(dat$mainplot)
dat$subplot  <- as.factor(dat$subplot)

plot(y=dat$proline, x=dat$wat)

boxplot(data=dat, proline ~ carb + cult + wat,
        las=2)

### build our model
#    Trt part: all our treatment main effects 
#              and their interaction effects
# Design part: split-plot design

# lm(data    = dat,
#    formula = proline ~     carb   + cult   + wat)
#             #proline ~ a + carb_i + cult_j + wat_k

library(lme4)
library(lmerTest)

mod <- lmer(data    = dat,
            formula = proline ~ carb + cult + wat + 
                                carb:cult + carb:wat + cult:wat +
                                carb:cult:wat +
                                (1|mainplot) + (1|mainplot:subplot) )
# Backward Elimination
library(car)
# Step 1:
Anova(mod) # carb:cult:wat is n.s. - elminate it!
mod2 <- update(mod, . ~ . -carb:cult:wat)
# Step 2:
Anova(mod2) # carb:war is n.s. - eliminate it!
mod3 <- update(mod2, . ~ . -carb:wat)
# Step 3:
Anova(mod3) # carb:cult is n.s. - eliminate it!
mod4 <- update(mod3, . ~ . -carb:cult)
# Step 4:
Anova(mod4) # cult:wat is n.s. - eliminate it!
mod5 <- update(mod4, . ~ . -cult:wat)
# Step 5:
Anova(mod5) # carb is n.s. - eliminate it!
mod6 <- update(mod5, . ~ . -carb)
# Step 6:
Anova(mod6)

# Automatic Backward Elimination:
lmerTest::step(mod)

# Step 1: ANOVA
# Step 2a: Get the adjusted means for significant effects
# Step 2b: Compare them (e.g via t-test or Tukey-test)

library(emmeans)
means <- lsmeans(mod6, "cult")
output <- cld(means, details=T, Letters = "abcd")$emmeans

# Plot lsmeans (for cult)
ggplot(data=output, aes(x=cult)) +
  geom_bar(aes(y=lsmean), stat="identity") + 
  geom_errorbar(aes(ymin=lsmean-SE, ymax=lsmean+SE), 
                width=0.4) +
  geom_text(aes(y=lsmean+0.07, label=.group))

# Res-Pred Plot  
plot(mod)
# Q-Q Plot
qqnorm(resid(mod))
qqline(resid(mod))




