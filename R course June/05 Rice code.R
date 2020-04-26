rm(list=ls())
setwd("D:/Hohenheim/R course June")
library(data.table)
dt <- fread("05 Rice.txt")

dt$Block <- as.factor(dt$Block)
dt$N     <- as.factor(dt$N)
dt$Var   <- as.factor(dt$Var)

dt[order(Block, N, Var)]
table(dt$Block, dt$N, dt$Var)

# boxplots for first impression
boxplot(data=dt, Yield ~ N + Var, las=2)
boxplot(data=dt, Yield ~ N,       las=2)
boxplot(data=dt, Yield ~ Var,     las=2)

library(lme4)
library(lmerTest)
# full model
mod <- lmer(data    = dt,
            formula = Yield ~ N + Var + N:Var + Block + (1|Block:N))
summary(mod)
anova(mod)

library(emmeans)
means <- emmeans(mod, pairwise ~ Var | N)
means

output <- cld(means, details=T, Letters = letters,  adjust = "tukey")$emmeans
output
output <- as.data.table(output$emmeans)
output

#############################################################
# draw lsmeans graph in ggplot
library(ggplot2)
p <- ggplot(data=output, aes(x=Var))
p <- p + geom_bar(aes(y=emmean), stat="identity", width=0.8)
p <- p + geom_errorbar(aes(ymin=emmean-SE, ymax=emmean+SE), width=0.4)
p <- p + geom_text(aes(y=emmean+1500, label=.group))
p <- p + facet_wrap(~ N)
p

