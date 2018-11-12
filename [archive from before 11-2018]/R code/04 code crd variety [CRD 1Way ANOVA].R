rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")
crd <- read.delim("04 crd variety.txt")

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
#autoplot(mod) # Residual plots
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

#install.packages("ggplot2")
library(ggplot2)
p <- ggplot(data=output, aes(x=Variety))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8)
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+15, label=.group))

p # show plot

# plot adjusted means - option 2
output$.group <- gsub(" ", "", output$.group, fixed = TRUE) # remove spaces

q <- ggplot() + theme_classic()
  # Rohdaten (crd)
q <- q + geom_boxplot(data=crd, aes(x=Variety, y=Yield), 
               outlier.shape=NA, width=0.6)
q <- q + geom_jitter(data=crd, aes(x=Variety, y=Yield), 
              width=0.25, height=0, shape=1)
  # Ergebnisse (output)
q <- q + geom_point(data=output, aes(x=as.numeric(Variety)+0.4, y=emmean),
             col="red", shape=16, size=2)
q <- q + geom_errorbar(data=output, aes(x=as.numeric(Variety)+0.4, ymin=lower.CL, ymax=upper.CL),
                col="red", width=0.1)
q <- q + geom_text(data=output, aes(x=as.numeric(Variety)+0.5, y=emmean, label =.group),
                   col="red")

q # show plot  
  
  
  
  
  