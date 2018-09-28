rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")

library(data.table)
dat <- fread("06 crd repeated measures.txt")

# format multiple columns as.factor in one step
makefactor <- names(dat)[1:4] # vector of columns that should be factor
dat[, (makefactor) := lapply(.SD, as.factor), .SDcols=makefactor] # define all those columns as.factor

# rename columns
names(dat) <- c("Soil", "Trt", "Rep", "Week", "Quantity")

###########################################################################
# For more info on theory of repeated measures see ch. 7 of "Quantitative 
# Methods in Biosciences" and ch. 6 in "Mixed models for metric data"
###########################################################################

# Option 1: Each week separately

all.anovas <- list() #create an empty list to save multiple results later

# for-loop, goes through code multiple times.
# "i" will be 1, 2 and 3 - so the loop runs three times.
for(i in c(1,2,3)){
  mod <- lm(data    = dat[Week==i],
            formula = Quantity ~ Trt + Soil + Trt:Soil)
  all.anovas[[i]] <- anova(mod)
}

all.anovas # look at all three anova tables
all.anovas[[1]] # look a first anova table

# Option 2: Across weeks, accounting for correlation
library(nlme) # another mixed model package

# create a column that identifies a single plot
dat$plotID <- as.factor(paste0(dat$Soil, dat$Trt, dat$Rep))
# even nicer / more intuitive names:
dat$plotID <- as.factor(paste0("S", dat$Soil, "-T", dat$Trt, "-R", dat$Rep))

# full mixed model with correlation structure
mod <- lme(data   = dat,
           fixed  = Quantity ~ Trt + Soil + Week +
                    Trt:Soil + Trt:Week + Soil:Week +
                    Trt:Soil:Week,
           random = ~ 1|plotID,
           correlation = corAR1())
anova(mod) # Trt:Soil:Week is not significant - drop from model.
# plot(mod)                              # residual plot 1
# qqnorm(resid(mod)); qqline(resid(mod)) # residual plot 2
