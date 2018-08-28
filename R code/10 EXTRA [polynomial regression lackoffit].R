rm(list=ls()) #clean up environment
setwd("D:/User/pschmidt/Dropbox/0 PhD/05 Courses/R-SAS.Introductory.Courses/Datasets")

require(data.table)

DT <- fread("10 EXTRA Polynomial Reg.txt", dec=",")

# format all columns
DT$block <- as.factor(DT$block)
DT$plot  <- as.factor(DT$plot)
DT$N     <- as.numeric(DT$N)
DT$yield <- as.numeric(DT$yield)

# plot for first impression
plot(y=DT$yield, x=DT$N, col=DT$block, 
     ylab="yield", ylim=c(0, max(DT$yield)),
     xlab="Nitrogen [kg]")

### Lack-of-fit test (see p. 153 in Piepho's "Quantitative Methods in Biosciences")
# Step 1:
# Create lack-of-fit variable in dataset as a copy of x (i.e. N), but formatted as.factor
DT$lackfit <- as.factor(DT$N)

# Step 2: 
# Build the polynomial Regression as a sequence of models and test lack-of-fit

# Polynomial Regression of degree 0 with lack-of-fit
pol0 <- lm(data    = DT,
           formula = yield ~ block + lackfit)
anova(pol0) #lack-of-fit is significant -> model doesn't fit

# Polynomial Regression of degree 1 with lack-of-fit
pol1 <- lm(data    = DT,
           formula = yield ~ N + block + lackfit)
anova(pol1) #lack-of-fit is significant -> model doesn't fit

# Polynomial Regression of degree 2 with lack-of-fit
pol2 <- lm(data    = DT,
           formula = yield ~ N + I(N^2) + block + lackfit)
anova(pol2) #lack-of-fit is n.s. -> final model!

# Final model
mod <- lm(data    = DT,
           formula = yield ~ N + I(N^2) + block)
anova(mod)
# plot(mod) # residual plots
mod # Model for average block effect: yield = 9.7 + 0.4*N - 0.002*N² + e

### plot polynomial regression with ggplot
require(ggplot2)

ggplot(data=DT , aes(y=yield, x=N)) +
       geom_point() +
       ylim(c(0, max(DT$yield))) +
       stat_smooth(method='lm', se=FALSE, formula=y~poly(x,2))


