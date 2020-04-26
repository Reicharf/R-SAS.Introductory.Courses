# Usual first lines of code for any project:
rm(list=ls()) # Clean up environment
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten") # Set working directory
library(data.table)
crd <- fread("toytrial1 (1F crd) LM.txt") # Import file

# Completely randomized design (CRD)
# One-Way ANOVA

crd$Variety   <- as.factor(crd$Variety)
crd$Replicate <- as.factor(crd$Replicate)

# plot for first impression
plot(y=crd$Yield, x=crd$Variety)

# Fit general linear model 
###########################
# Treatment effects: Variety
# Design effects:    -
# Step 1: Check F-Test of ANOVA
# Step 2: Compare adjusted means per level
mod <- lm(data    = crd,
          formula = Yield ~ Variety)

library(ggfortify)
autoplot(mod) # Residual plots
mod           # Basic results
summary(mod)  # More detailed results
anova(mod)    # ANOVA-table: Variety effect is significant

library(emmeans) # also needs package multcompView to be installed

# get means and comparisons
means  <- emmeans(mod, pairwise ~ Variety, adjust = "tukey") # to get t-test: adjust="none"
means # look at means and differences between means
means$emmeans   # look at means
means$contrasts # look at differences between means

# add letters indicating significant differences between means
output <- CLD(means$emmeans, Letters=letters)

# plot adjusted means - option 1
################################

#install.packages("ggplot2")
library(ggplot2)
p <- ggplot(data=output, aes(x=Variety))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8)
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+15, label=.group))

p # show plot