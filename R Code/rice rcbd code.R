rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten")
library(data.table)
rice <- fread("rice (2F rcbd) LM.txt")

# Randomized Complete Block Design
# Two-Way ANOVA

rice$G   <- as.factor(rice$G)
rice$N   <- as.factor(rice$N)
rice$rep <- as.factor(rice$rep)

# plot for first impression
plot(y=rice$yield, x=rice$G)
plot(y=rice$yield, x=rice$N)
plot(y=rice$yield, x=rice$rep)
boxplot(data=rice, yield ~ G + N, las=2)


# Fit general linear model 
###########################
# Treatment effects: G, N and their interaction
# Design effects:    rep
# Step 1: Check F-Test of ANOVA and perform backwards elimination
# Step 2: Compare adjusted means per level
mod <- lm(data    = rice,
          formula = yield ~ G + N + G:N + rep)

anova(mod) # Interaction is significant -> Final model

library(ggfortify)
autoplot(mod) # Residual plots

#install.packages("emmeans")
library(emmeans)

# get means and comparisons
means  <- emmeans(mod, pairwise ~ N|G, adjust = "tukey") # to get t-test: adjust="none"
means # look at means and comparisons
means$emmeans   # look at means
means$contrasts # look at comparions

# add letters indicating significant differences
means  <- CLD(means$emmeans, details=T, Letters = letters)
plotit <- as.data.table(means$emmeans)

# plot adjusted means
library(ggplot2)
ggplot(data=plotit, aes(x=N)) +
  geom_bar(aes(y=emmean, fill=N), stat="identity", width=0.8) +
  geom_errorbar(aes(ymin=lower.CL, ymax=upper.CL), width=0.4) +
  geom_text(aes(y=emmean+1500, label=.group)) +
  facet_wrap(~G) + 
  theme_bw()

# alternative, more complex plot
#################################

# remove spaces
plotit$.group <- gsub(" ", "", plotit$.group, fixed = TRUE) 

ggplot() + theme_bw() +
  # Rohdaten (crd)
  geom_boxplot(data=rice, 
               aes(x=N, y=yield), 
               outlier.shape=NA, width=0.6) +
  geom_jitter(data=rice, 
              aes(x=N, y=yield), 
              width=0.25, height=0, shape=1) +
  # Ergebnisse (means)
  geom_point(data=plotit, 
             aes(x=as.numeric(N)+0.4, y=emmean), 
             col="red", shape=16, size=2) +
  geom_errorbar(data=plotit, 
                aes(x=as.numeric(N)+0.4, ymin=lower.CL, ymax=upper.CL), 
                col="red", width=0.1) +  
  geom_text(data=plotit, 
            aes(x=N, y=9600, label=.group), 
            col="red") +
  facet_wrap(~G) + 
  ylim(0, 10000)
