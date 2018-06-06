rm(list=ls())
crd <- read.delim("D:/User/pschmidt/Desktop/crd cultivar.txt")

crd$Cultivar  <- as.factor(crd$Cultivar)
crd$Replicate <- as.factor(crd$Replicate)

plot(y=crd$Yield, x=crd$Variety)

mod <- lm(data    = crd,
          formula = Yield ~ Variety)

mod
summary(mod)
anova(mod)

library(emmeans)
means  <- lsmeans(mod, "Variety")
output <- cld(means, details=T, Letters = "abcd")$emmeans

library(ggplot2)
ggplot(data=output, aes(x=Variety)) +
  geom_bar(aes(y=lsmean), stat="identity", width=0.8) + 
  geom_errorbar(aes(ymin=lsmean-SE, ymax=lsmean+SE), width=0.4) +
  geom_text(aes(y=lsmean+15, label=.group))
