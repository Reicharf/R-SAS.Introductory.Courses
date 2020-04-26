rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten")
library(data.table)
library(emmeans)
library(ggplot2); library(ggfortify)
library(nlme)
lemna <- fread("lemna (1F crd repmes) GLS.txt")

# Completely randomized design
# 

lemna$grp   <- as.factor(lemna$grp)
lemna$plant <- as.factor(lemna$plant)
lemna$ftime <- as.factor(lemna$ftime) # time as factor

# Plot for first impression
ggplot(data=lemna, aes(y=y, x=grp)) + # overall
  geom_boxplot()

ggplot(data=lemna, aes(y=y, x=time, col=grp)) + # over time
  geom_point()

### Option 1: Analyze weeks separately
# Analyzing only week 1:
lemna.wk1 <- lemna[time=="1"]
mod.wk1 <- lm(y ~ grp, data=lemna.wk1)
anova(mod.wk1)

# Analyzing all 3 weeks in a loop
anova.list <- list() # create an empty list object

for (wochen.nr in c("1", "5", "7")){ # start loop through week.nr = 1 ,5, 7
  lemna.wkX <- lemna[time==wochen.nr]
  mod.wkX <- lm(y ~ grp, data=lemna.wkX)
  anova.list[[wochen.nr]] <- anova(mod.wkX)
} # Loop end

anova.list[["1"]] # show first week anova
anova.list[["5"]]
anova.list[["7"]] 

### Option 2: Analyze across weeks 
# no covar str
mod.iid <- gls(y ~ grp*ftime,
               data = lemna)

# ar1 covar str
mod.ar1 <- gls(y ~ grp*ftime,
               corr = corExp(form = ~ ftime|plant),
               data = lemna)

mod.iid$sigma^2 # IID.var 
mod.ar1$sigma^2 # AR1.var 
as.numeric(exp(-1/coef(mod.ar1$modelStruct$corStruct, unconstrained=F))) # AR1.cor

AIC(mod.iid)
AIC(mod.ar1) # smaller AIC is better

# ANOVA
anova(mod.ar1) # interaction is significant

# mean comparisons
means <- emmeans(mod.ar1, pairwise ~ grp|ftime, adjust="tukey") # adjust="none" for t-test
means <- CLD(means$emmeans, details=TRUE, Letters=letters)
means$emmeans 

means.plot <- as.data.table(means$emmeans) # correct format for ggplot
means.plot$.group <- gsub(" ", "", means.plot$.group, fixed = TRUE) # remove spaces

# Visualize results
ggplot(data=means.plot, aes(x=ftime)) +                 # dataset:output, x-axis: week
   geom_bar(aes(y=emmean), stat="identity") +           # vertical bars of heigt in "emmean" column
   geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE)) + # error bars from ymin to ymax
   geom_text(aes(y=emmean+0.5, label=.group)) +         # letters of ".group"-column
   facet_wrap(~grp)                                     # one plot per "gen"

# or
ggplot(data=means.plot, aes(x=grp, fill=ftime)) +
   geom_bar(aes(y=emmean), stat="identity",           position=position_dodge(width=1)) +
   geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), position=position_dodge(width=1)) +
   geom_text(aes(y=emmean+0.5, label=.group),         position=position_dodge(width=1.22))
 


