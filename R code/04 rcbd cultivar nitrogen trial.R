rm(list=ls())
rcbd2f <- read.delim("D:/User/pschmidt/Desktop/rcbd cultivar nitrogen.txt")

rcbd2f$Variety    <- as.factor(rcbd2f$Variety)
rcbd2f$Fertilizer <- as.factor(rcbd2f$Fertilizer)
rcbd2f$Block      <- as.factor(rcbd2f$Block)

plot(y=rcbd2f$Yield, x=rcbd2f$Variety)
plot(y=rcbd2f$Yield, x=rcbd2f$Fertilizer)
plot(y=rcbd2f$Yield, x=rcbd2f$Block)
boxplot(data=rcbd2f, Yield ~ Variety + Fertilizer, las=2)

mod <- lm(data    = rcbd2f,
          formula = Yield ~ Variety + Fertilizer + Variety:Fertilizer + Block)

mod
summary(mod)
anova(mod)

mod2 <- update(mod, . ~ . -Variety:Fertilizer)
mod2
anova(mod2)

mod3 <- update(mod2, . ~ . -Fertilizer)
anova(mod3)

library(emmeans)
means  <- lsmeans(mod, "Variety")
output <- cld(means, details=T, Letters = "abcd")$emmeans

library(ggplot2)
ggplot(data=output, aes(x=Variety)) +
  geom_bar(aes(y=lsmean), stat="identity", width=0.8) + 
  geom_errorbar(aes(ymin=lsmean-SE, ymax=lsmean+SE), width=0.4) +
  geom_text(aes(y=lsmean+15, label=.group))
