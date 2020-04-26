rm(list=ls())
setwd("D:/Hohenheim/R course June")
library(data.table)
dt <- fread("06 data Quantity.txt")

names(dt) <- c("Soil", "Trt", "Rep", "Week", "Quant")

dt$Soil <- as.factor(dt$Soil)
dt$Trt  <- as.factor(dt$Trt)
dt$Rep  <- as.factor(dt$Rep)
dt$Week <- as.factor(dt$Week)

# Option 1: Each week separately

all.anovas <- list()

for(i in c(1,2,3)){
  mod <- lm(data    = dt[Week==i],
            formula = Quant ~ Trt + Soil + Trt:Soil)
  all.anovas[[i]] <- anova(mod)
}

# Option 2: Across weeks, accounting for correlation
library(nlme)

dt$plotID <- as.factor(paste0(dt$Soil, dt$Trt, dt$Rep))

mod <- lme(data   = dt,
           fixed  = Quant ~ Trt + Soil + Week +
                            Trt:Soil + Trt:Week + Soil:Week +
                            Trt:Soil:Week,
           random = ~ 1|plotID,
           correlation = corAR1())
anova(mod)













