rm(list=ls())
setwd("D:/Hohenheim/R-SAS.Introductory.Courses/Daten")
library(data.table)
beet <- fread("beet (1F rcbd polynom) LM.txt")

# format columns
beet$block    <- as.factor(beet$block)
beet$n.amount <- as.numeric(beet$n.amount)
beet$yield    <- as.numeric(beet$yield)

# plot for first impression
ggplot(data=beet, aes(x=n.amount, y=yield, color=block)) +
  geom_point() +
  ylim(c(0, max(beet$yield))) +
  scale_x_continuous(breaks=unique(beet$n.amount))

### The plot indicates that a straight line relationship (y=a+bx) 
### may not be a good fit to the data. One way of fitting a
### non-linear regression, is the polynomial regression. A polynom
### is a linear combination of independent variable x as:
### 0th: a + b*x^0                 = a                  
### 1st: a + b*x^1                 = a + b*x            - added linear term
### 2nd: a + b*x^1 + c*x^2         = a + bx + cx²       - added quadratic term
### 3rd: a + b*x^1 + c*x^2 + d*x^3 = a + bx + cx² + dx³ - added cubed term
### and so on..
### Thus, it needs to be determined which polynomial degree should be
### used. This can be done via the lack-of-fit method.
###
### For more info on repeated measures see ch. 6.11 of "Biometrie", 
### ch. 5.8 in "Quantitative Methods in Biosciences", ch. 5.3 in
### "Mixed models for metric data" and Example 2 of Piepho HP, 
### Edmondson RN. A tutorial on the statistical analysis of 
### factorial experiments with qualitative and quantitative treatment 
### factor levels. J Agro Crop Sci. 2018;204:429-455.

# get visual impression of different polynomes via ggplot
library(ggplot2)
ggplot(data=beet, aes(x=n.amount, y=yield)) +
  geom_point() +
  ylim(c(0, max(beet$yield))) +
  scale_x_continuous(breaks=unique(beet$n.amount)) +
  stat_smooth(method='lm', se=FALSE, formula=y~1         , color="blue") +
  stat_smooth(method='lm', se=FALSE, formula=y~poly(x, 1), color="red") +
  stat_smooth(method='lm', se=FALSE, formula=y~poly(x, 2), color="orange") +
  stat_smooth(method='lm', se=FALSE, formula=y~poly(x, 3), color="yellow")
# It seems that adding the cubic term did not really improve the model fit.
# Now we confirm this properly via the lack-of-fit method:

# Define a lack-of-fit term as "a factor version of the numeric x variable"
beet$lackfit <- as.factor(beet$n.amount)

# "Build" polynomial regression sequentially until lack-of-fit term is no
# longer significant. Notice that we have a block effect, since this
# experiment was laid out as an RCBD.

# Degree 0:
pol0 <- lm(data    = beet,
           formula = yield ~ block + lackfit)
anova(pol0) #lack-of-fit is significant -> model doesn't fit

# Add linear term:
pol1 <- lm(data    = beet,
           formula = yield ~ n.amount + block + lackfit)
anova(pol1) #lack-of-fit is significant -> model doesn't fit

# Add quadratic term
pol2 <- lm(data    = beet,
           formula = yield ~ n.amount + I(n.amount^2) + block + lackfit)
anova(pol2) #lack-of-fit is n.s. -> final model!

# Final model without lack-of-fit term
mod <- lm(data    = beet,
          formula = yield ~ n.amount + I(n.amount^2) + block)

autoplot(mod)    # Residual plots
anova(mod)       # ANOVA
Sol <- mod$coefficients # Effect estimates
Sol
# Block 1 model: yield = 9.14 + 0.42x - 0.002x² + 0
# Block 2 model: yield = 9.14 + 0.42x - 0.002x² - 0.72
# Block 3 model: yield = 9.14 + 0.42x - 0.002x² + 2.38

mean.block.effect <- mean(c(0, -0.72, 2.38))
mean.block.effect
9.14 + mean.block.effect
# Mean Block model: yield = 9.14 + 0.42x - 0.002x² + 0.55
#                   yield = 9.69 + 0.42x - 0.002x²


# get model predictions
beet.out <- cbind(beet, predict(mod))

# A prediction plot
ggplot(data=beet.out, aes(x=n.amount, y=yield, col=block)) +
  geom_point(shape = 1) +
  geom_line(aes(y=V2, x=n.amount)) +
  ylim(c(0, max(beet$yield))) +
  scale_x_continuous(breaks=unique(beet$n.amount)) +
  labs(x="Amount of nitrogen (kg)", y="Yield") +
  theme_bw()
