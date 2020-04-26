rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten")
library(data.table)
library(emmeans)
library(desplot)
library(ggplot2); library(ggfortify)
bugs <- fread("bugs (1F latsq poisson) GLM.txt")

# Latin Square Design
# One factor
# Poisson data

bugs$Row <- as.factor(bugs$Row)
bugs$Col <- as.factor(bugs$Col)
bugs$trt <- as.factor(bugs$trt) 

# Field plan
desplot(data=bugs, form= trt ~ col+row,
        text=trt, shorten="no", cex=0.8,
        out1=Col, out1.gpar=list(col="black", size=1.5),
        out2=Row, out2.gpar=list(col="black", size=1.5),
        main="", show.key=F)

# Plot for first impression
boxplot(bugs ~ trt, data=bugs, las=2) 

# Generalized linear model
mod <- glm(bugs ~ trt + Row + Col, family=quasipoisson(link="log"), data=bugs)
autoplot(mod) # Residual plots

# Analysis of Deviance
anova(mod, test="F") # trt significant

# Mean comparisons
means <- emmeans(mod, pairwise ~ trt, type="response") # Mittelwertvergleiche
means <- CLD(means$emmeans, Letters = letters) # Buchstabenddarstellung
means$.group <- gsub(" ", "", means$.group, fixed = TRUE) # Entferne Leerzeichen
means

# Visualize results
ggplot() + theme_classic() +
  # raw data (bugs)
  geom_boxplot(data=bugs, aes(x=trt, y=bugs), outlier.shape=NA, width=0.6) +
  geom_jitter(data=bugs, aes(x=trt, y=bugs), width=0.1, shape=1, size=2) +
  # results (means)
  geom_point(data=means, aes(x=as.numeric(trt)+0.4, y=rate), col="red", shape=16, size=2) +
  geom_errorbar(data=means, aes(x=as.numeric(trt)+0.4, ymin=asymp.LCL, ymax=asymp.UCL), col="red", width=0.1) +
  geom_text(data=means, aes(x=trt, y=11, label =.group), col="red")

