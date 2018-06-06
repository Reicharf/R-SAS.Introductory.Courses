rm(list=ls())
rcbd <- read.delim("D:/User/pschmidt/Desktop/rcbd cultivar.txt")

rcbd$Variety <- as.factor(rcbd$Variety)
rcbd$Block   <- as.factor(rcbd$Block)

plot(y=rcbd$Yield, x=rcbd$Variety)
plot(y=rcbd$Yield, x=rcbd$Block)
boxplot(data=rcbd, Yield ~ Variety + Block, las=2)

mod <- lm(data    = rcbd,
          formula = Yield ~ Variety + Block)

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
