rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten")
library(data.table)
rcbd2 <- fread("toytrial3 (2F rcbd) LM.txt")

# Randomized Complete Block Design
# Two-Way ANOVA

rcbd2$Variety    <- as.factor(rcbd2$Variety)
rcbd2$Fertilizer <- as.factor(rcbd2$Fertilizer)
rcbd2$Block      <- as.factor(rcbd2$Block)

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

#install.packages("emmeans")
library(emmeans)

# get means and comparisons
means  <- emmeans(mod3, pairwise ~ Variety, adjust = "tukey") # to get t-test: adjust="none"
means # look at means and comparisons
means$emmeans   # look at means
means$contrasts # look at comparions

# add letters indicating significant differences
means  <- CLD(means$emmeans, details=T, Letters = letters)
plotit <- means$emmeans

# plot adjusted means
library(ggplot2)
p <- ggplot(data=plotit, aes(x=Variety))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8)
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+15, label=.group))

p # show plot

# alternative, more complex plot
#################################

# remove spaces
plotit$.group <- gsub(" ", "", plotit$.group, fixed = TRUE) 

ggplot() + theme_classic() +
  # Raw data (crd)
  geom_boxplot(data=rcbd2, 
               aes(x=Variety, y=Yield), 
               outlier.shape=NA, width=0.6) +
  geom_jitter(data=rcbd2,  
              aes(x=Variety, y=Yield), 
              width=0.1, height=0, shape=1) +
  # Ergebnisse (means)
  geom_point(data=plotit, 
             aes(x=as.numeric(Variety)+0.4, y=emmean), 
             col="red", shape=16, size=2) +
  geom_errorbar(data=plotit, 
                aes(x=as.numeric(Variety)+0.4, 
                    ymin=lower.CL, ymax=upper.CL), 
                col="red", width=0.1) +
  geom_text(data=plotit, 
            aes(x=as.numeric(Variety)+0.5, y=emmean, label=.group), 
            col="red")
