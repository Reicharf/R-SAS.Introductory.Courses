rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten")
library(data.table)
library(emmeans)
library(ggplot2); library(ggfortify)
carrot <- fread("carrot (1F rcbd binomial) GLM.txt")

# Randomized complete block design
# Two factors
# Binomial data

carrot$trt   <- as.factor(carrot$trt)
carrot$gen   <- as.factor(carrot$gen)
carrot$block <- as.factor(carrot$block) 

carrot[,portion := y/n] # create new column "portion"

# Plot for first impression
boxplot(portion ~ gen,       data=carrot, las=2) 
boxplot(portion ~ trt,       data=carrot, las=2) 
boxplot(portion ~ gen + trt, data=carrot, las=2) 


# Generalized linear model
mod <- glm(portion ~ gen + trt + gen:trt + block, 
           family=quasibinomial(link="logit"), data=carrot)
anova(mod, test="F") # interaction n.s.

mod2 <- update(mod, . ~ . -gen:trt) # reduce model (i.e. backwards elimination)
anova(mod2, test="F") # both main effects significant


# Mean comparisons
# trt
means.trt <- emmeans(mod2, pairwise ~ trt, type="response") # Mittelwertvergleiche
means.trt <- CLD(means.trt$emmeans, Letters = letters) # Buchstabenddarstellung
means.trt$.group <- gsub(" ", "", means.trt$.group, fixed = TRUE) # Entferne Leerzeichen
means.trt

# gen
means.gen <- emmeans(mod2, pairwise ~ gen, type="response") # Mittelwertvergleiche
means.gen <- CLD(means.gen$emmeans, Letters = letters) # Buchstabenddarstellung
means.gen$.group <- gsub(" ", "", means.gen$.group, fixed = TRUE) # Entferne Leerzeichen
means.gen


# Visualize results 
carrot$prob <- carrot$y/(carrot$n-carrot$y) # create column similar to the one in "means"

# trt
ggplot() + theme_classic() +
  # raw data (bugs)
  geom_boxplot(data=carrot, aes(x=trt, y=prob), outlier.shape=NA, width=0.6) +
  geom_jitter(data=carrot, aes(x=trt, y=prob), width=0.1, shape=1, size=2) +
  # results (means.trt)
  geom_point(data=means.trt, aes(x=as.numeric(trt)+0.4, y=prob), col="red", shape=16, size=2) +
  geom_errorbar(data=means.trt, aes(x=as.numeric(trt)+0.4, ymin=asymp.LCL, ymax=asymp.UCL), col="red", width=0.1) +
  geom_text(data=means.trt, aes(x=trt, y=2, label =.group), col="red")

# gen
ggplot() + theme_classic() +
  # raw data (bugs)
  geom_boxplot(data=carrot, aes(x=gen, y=prob), outlier.shape=NA, width=0.6) +
  geom_jitter(data=carrot, aes(x=gen, y=prob), width=0.1, shape=1, size=2) +
  # results (means.gen)
  geom_point(data=means.gen, aes(x=as.numeric(gen)+0.4, y=prob), col="red", shape=16, size=2) +
  geom_errorbar(data=means.gen, aes(x=as.numeric(gen)+0.4, ymin=asymp.LCL, ymax=asymp.UCL), col="red", width=0.1) +
  geom_text(data=means.gen, aes(x=gen, y=2, label =.group), col="red")