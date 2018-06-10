rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Datasets")

library(data.table)
dt <- fread("06 crd repeated measures.txt")

# rename multiple columns
names(dt) <- c("Soil", "Trt", "Rep", "Week", "Quant")

dt$Soil <- as.factor(dt$Soil)
dt$Trt  <- as.factor(dt$Trt)
dt$Rep  <- as.factor(dt$Rep)
dt$Week <- as.factor(dt$Week)

# Option 1: Each week separately

all.anovas <- list() #create an empty list to save multiple results in later

# for-loop, goes through code multiple times.
# "i" will be 1, 2 and 3 - so the loop runs three times.
for(i in c(1,2,3)){
  mod <- lm(data    = dt[Week==i],
            formula = Quant ~ Trt + Soil + Trt:Soil)
  all.anovas[[i]] <- anova(mod)
}

all.anovas # look at all three anova tables
all.anovas[[1]] # look a first anova table

# Option 2: Across weeks, accounting for correlation
library(nlme)

# create a column that identifies a single plot
dt$plotID <- as.factor(paste0(dt$Soil, dt$Trt, dt$Rep))
# even nicer / more intuitive names:
dt$plotID <- as.factor(paste0("S", dt$Soil, "-T", dt$Trt, "-R", dt$Rep))

# mixed model with correlation structure
mod <- lme(data   = dt,
           fixed  = Quant ~ Trt + Soil + Week +
                    Trt:Soil + Trt:Week + Soil:Week +
                    Trt:Soil:Week,
           random = ~ 1|plotID,
           correlation = corAR1())
anova(mod)
