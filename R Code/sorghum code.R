rm(list=ls())
setwd("D:/RKurse/newKurs/Daten")
library(data.table)
dat <- fread("sorghum (1F rcbd repmes) GLS.txt")

# format multiple columns as.factor in one step
makefactor <- names(dat)[1:3] # names of column that should be factor
dat[, (makefactor) := lapply(.SD, as.factor), .SDcols=makefactor] # define all those columns as.factor

# rename "rep" column for clearer indication that it represents a complete block
names(dat)[3] <- "block"

# plots for first impression
plot(y=dat$y, x=dat$gen)        # boxplot in plot()
library(ggplot2)
ggplot(data=dat, aes(y=y, x=gen)) + # same plot in ggplot()
  geom_boxplot()

ggplot(data=dat, aes(y=y, x=gen, fill=week)) + # per week
  geom_boxplot()

### In this experiment, the observational units (=plots) were actually
### measured multiple times: once per week, over five weeks. This is called
### "repeated measures" or "repeated measurements". 
### The aim of the experiment is (just like in the last examples) to compare 
### treatment levels (=varieties). And since we here have an RCBD with variety
### being the only treatment and qualitative factor.
### The difference, however, is that due to the repeated measures, the error
### term of the model should be allowed to be correlated between weeks.
###
### For more info on repeated measures see ch. 7 of "Quantitative 
### Methods in Biosciences", ch. 6 in "Mixed models for metric data"
### and Example 4 of Piepho HP, Edmondson RN. A tutorial on the statistical 
### analysis of factorial experiments with qualitative and quantitative 
### treatment factor levels. J Agro Crop Sci. 2018;204:429-455.

# Option 1: Analyze each week separately
########################################
# and thus avoid the repeated measures "problem"

# Analyzing only week 1:
mod.wk1 <- lm(data    = dat[week=="1"],
              formula = y ~ gen + block)
anova(mod.wk1) # and so on ...

# Analyzing all 5 weeks separately in a loop
result.list <- list() # create an empty list object

for (week.nr in 1:5){ # start loop through week.nr = 1 to 5
  mod <- lm(data    = dat[week==week.nr], 
            formula = y ~ gen + block)
  result.list[[week.nr]] <- anova(mod) # save anove into list
} # end loop

result.list      # show complete list of all 5 ANOVAs
result.list[[1]] # show first week ANOVA
result.list[[5]] # show fifth week ANOVA

# Option 2: Analyze across weeks 
################################
# and account for repeated measures "problem" via assuming
# a variance-covariance structure for the error term

# create a column that identifies a single plot
dat$plotID <- as.factor(paste0(dat$gen, dat$block))
# optional: even nicer / more intuitive names:
dat$plotID <- as.factor(paste0("v", dat$gen, "-r", dat$block))

### We fit 4 popular variance-covariance structures: ID, AR1, CS and UN
library(nlme)

# ID: independent, uncorrelated random plot error
mod.id <- gls(data  = dat, 
              model = y ~ week + week*gen + week*block)

# AR1: first-order autoregressive 
mod.ar <- gls(data  = dat, 
              model = y ~ week + week*gen + week*block,
              corr  = corExp(form = ~ week|plotID))

# CS: compound symmetry
mod.cs <- gls(data  = dat, 
              model = y ~ week + week*gen + week*block,
              corr  = corCompSymm(form = ~ week|plotID))

# UN: Unstructured
mod.un <- gls(data  = dat, 
              model = y ~ week + week*gen + week*block,
              corr  = corSymm(form = ~ 1|plotID),
              weights = varIdent(form = ~ 1|week))

# Which model do I choose? 
# If models have the same fixed effects, but differ in their random/error part, 
# the Akaike Information Criterion (AIC) is an often used model selection 
# criterion. The smaller AIC the better is the model.

AIC(mod.id) # get the AIC for mod.id

AICs <- data.table(model = c("ID", "AR", "CS", "UN"),
                   AIC   = c(AIC(mod.id), AIC(mod.ar), AIC(mod.cs), AIC(mod.un)))
AICs[order(AIC)] # both AR and CS models are best.

# Choose AR model
#################

# residual plots
plot(mod.ar)                                
qqnorm(resid(mod.ar)); qqline(resid(mod.ar))

anova(mod.ar) # all effects significant - final model

# get means and comparisons
library(emmeans)
means <- emmeans(mod.ar, pairwise ~ week | gen, adjust = "tukey") # to get t-test: adjust="none"
# Note that week | gen gets pairwise vat comparisons for each
# week separately. You can use weeK.gen instead to get all
# pairwise comparisons.

means # look at means and comparisons
means$emmeans   # look at means
means$contrasts # look at comparions

means  <- CLD(means$emmeans, details=T, Letters = letters)
means # this data format is not good for ggplot
plotit <- as.data.table(means$emmeans) # reformatting into one table
plotit$.group <- gsub(" ", "", plotit$.group, fixed = TRUE) # remove spaces
plotit # this is better

# plot adjusted means per week
p <- ggplot(data=plotit, aes(x=week))                        # dataset:output, x-axis: week
p <- p + geom_bar(aes(y=emmean), stat="identity")            # vertical bars of heigt in "emmean" column
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE))  # error bars from ymin to ymax
p <- p + geom_text(aes(y=emmean+0.5, label=.group))          # letters of ".group"-column
p <- p + facet_wrap(~gen)                                    # one plot per "gen"
p

# or

p <- ggplot(data=plotit, aes(x=gen, fill=week))
p <- p + geom_bar(aes(y=emmean), stat="identity",           position=position_dodge(width=1)) 
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), position=position_dodge(width=1))
p <- p + geom_text(aes(y=emmean+0.5, label=.group),         position=position_dodge(width=1.22))
p
